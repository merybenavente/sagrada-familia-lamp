#include <WiFi.h>
#include <time.h>
#include <IRremoteESP8266.h>
#include <IRsend.h>

// ---------- CONFIG: fill in your WiFi ----------
const char* WIFI_SSID = "YOUR_WIFI_NAME";
const char* WIFI_PASS = "YOUR_WIFI_PASSWORD";

const char* TZ_INFO = "CET-1CEST,M3.5.0,M10.5.0/3";  // Barcelona. New York: "EST5EDT,M3.2.0,M11.1.0"
// -----------------------------------------------

IRsend irsend(9);  // D10 on XIAO ESP32S3 = GPIO 9

uint16_t WARM_WHITE[] = {
  700,1400,1400,700,700,700,1400,2800,700,1400,700,700,700,2100,700,1400,1400,
  1400,700,2100,700,2800,700,1400,700,700,1400,700,700,700,700,700,700,1400,700,
  1400,700,2800,700
};
const uint16_t LEN = sizeof(WARM_WHITE) / sizeof(WARM_WHITE[0]);

void fireEffect() {
  irsend.begin();
  for (int i = 0; i < 3; i++) {
    irsend.sendRaw(WARM_WHITE, LEN, 38);
    delay(200);
  }
}

bool syncNTP() {
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

  // Sync real time every wake via NTP
  if (!syncNTP()) {
    // No WiFi, retry in 5 min
    esp_sleep_enable_timer_wakeup(300ULL * 1000000ULL);
    esp_deep_sleep_start();
  }

  struct tm now;
  time_t t = time(NULL);
  localtime_r(&t, &now);

  // Fire if within 2 minutes of the hour (before or after)
  if (now.tm_min <= 1 || now.tm_min >= 59) fireEffect();

  // Sleep until next hour
  int secsToNext = 3600 - (now.tm_min * 60 + now.tm_sec);
  if (secsToNext < 60) secsToNext += 3600;
  esp_sleep_enable_timer_wakeup((uint64_t)secsToNext * 1000000ULL);
  esp_deep_sleep_start();
}

void loop() {}
