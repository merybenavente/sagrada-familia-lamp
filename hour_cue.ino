#include <WiFi.h>
#include <time.h>
#include <IRremoteESP8266.h>
#include <IRsend.h>

// ---------- CONFIG: fill in your WiFi ----------
const char* WIFI_SSID = "YOUR_WIFI_NAME";
const char* WIFI_PASS = "YOUR_WIFI_PASSWORD";

const char* TZ_INFO = "CET-1CEST,M3.5.0,M10.5.0/3";  // Barcelona. New York: "EST5EDT,M3.2.0,M11.1.0"

const int ACTIVE_START = 9;    // fire from 09:00 ...
const int ACTIVE_END   = 22;   // ... through 22:00
// -----------------------------------------------

IRsend irsend(10);

uint16_t WARM_WHITE[] = {
  700,1400,1400,700,700,700,1400,2800,700,1400,700,700,700,2100,700,1400,1400,
  1400,700,2100,700,2800,700,1400,700,700,1400,700,700,700,700,700,700,1400,700,
  1400,700,2800,700
};
const uint16_t LEN = sizeof(WARM_WHITE) / sizeof(WARM_WHITE[0]);

RTC_DATA_ATTR uint32_t bootMagic    = 0;
RTC_DATA_ATTR time_t   estimatedNow = 0;
RTC_DATA_ATTR int      lastSyncYday = -1;

void fireEffect() {
  irsend.begin();
  for (int i = 0; i < 3; i++) {
    irsend.sendRaw(WARM_WHITE, LEN, 38);
    delay(200);
  }
}

bool syncTimeOverWifi() {
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  unsigned long start = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - start < 15000) delay(250);
  if (WiFi.status() != WL_CONNECTED) {
    WiFi.mode(WIFI_OFF);
    return false;
  }
  configTzTime(TZ_INFO, "pool.ntp.org", "time.nist.gov");
  struct tm t;
  bool ok = getLocalTime(&t, 10000);
  WiFi.disconnect(true);
  WiFi.mode(WIFI_OFF);
  return ok;
}

void setup() {
  setenv("TZ", TZ_INFO, 1);
  tzset();

  bool coldBoot = (bootMagic != 0xCAFE);

  struct tm now;
  if (!coldBoot) localtime_r(&estimatedNow, &now);

  if (coldBoot || now.tm_yday != lastSyncYday) {
    if (syncTimeOverWifi()) {
      time(&estimatedNow);
      localtime_r(&estimatedNow, &now);
      lastSyncYday = now.tm_yday;
      bootMagic = 0xCAFE;
    } else if (coldBoot) {
      esp_sleep_enable_timer_wakeup(300ULL * 1000000ULL);
      esp_deep_sleep_start();
    }
  }

  bool inWindow  = (now.tm_hour >= ACTIVE_START && now.tm_hour <= ACTIVE_END);
  bool topOfHour = (now.tm_min == 0 && now.tm_sec < 59);
  if (inWindow && topOfHour) fireEffect();

  int secsToNext = 3600 - (now.tm_min * 60 + now.tm_sec);
  if (secsToNext < 1) secsToNext = 1;
  estimatedNow += secsToNext;
  esp_sleep_enable_timer_wakeup((uint64_t)secsToNext * 1000000ULL);
  esp_deep_sleep_start();
}

void loop() {}
