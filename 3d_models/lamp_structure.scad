// ============================================
// Faceted column - Gaudí style
// Height: 240mm, fits 60x50mm base
// Solid, with waist, triangular facets
// ============================================

/* [Column] */
total_h   = 240;  // Total height (mm) [50:10:500]
base_w    = 55;   // Base width (mm) [10:1:150]
base_d    = 45;   // Base depth (mm) [10:1:150]
top_w     = 40;   // Top width (mm) [10:1:150]
top_d     = 33;   // Top depth (mm) [10:1:150]
waist_w   = 28;   // Waist width (mm) [10:1:150]
waist_d   = 23;   // Waist depth (mm) [10:1:150]
waist_pos = 0.42; // Waist position [0:0.01:1]
sections  = 24;   // Sections (more = smoother) [8:1:64]

/* [Base] */
plinth_w = 75;  // Base width (mm) [10:1:200]
plinth_d = 65;  // Base depth (mm) [10:1:200]
plinth_h = 8;   // Base height (mm) [2:1:30]

// --- Profile ---
function smooth(t) = t * t * (3 - 2 * t);

function profile_w(t) =
    t <= waist_pos
        ? base_w + (waist_w - base_w) * smooth(t / waist_pos)
        : waist_w + (top_w - waist_w) * smooth((t - waist_pos) / (1 - waist_pos));

function profile_d(t) =
    t <= waist_pos
        ? base_d + (waist_d - base_d) * smooth(t / waist_pos)
        : waist_d + (top_d - waist_d) * smooth((t - waist_pos) / (1 - waist_pos));

module faceted_column() {
    for (i = [0 : sections - 1]) {
        t0 = i / sections;
        t1 = (i + 1) / sections;
        z0 = t0 * total_h;
        z1 = i == sections -1 ? (t1 * total_h)+20    : t1 * total_h;
        w0 = profile_w(t0) / 2;
        d0 = profile_d(t0) / 2;
        w1 = profile_w(t1) / 2;
        d1 = profile_d(t1) / 2;

        // Alternating rotation for diamond/facet effect
        rot0 = (i % 2 == 0) ? 0 : 45;
        rot1 = (i % 2 == 0) ? 45 : 0;

        hull() {
            translate([0, 0, z0])
                rotate([0, 0, rot0])
                    scale([w0, d0, 1])
                        cylinder(h = 0.01, r = 1, $fn = 4);

            translate([0, 0, z1])
                rotate([0, 0, rot1])
                    scale([w1, d1, 1])
                        cylinder(h = 0.01, r = 1, $fn = 4);
        }
    }
}

module square_base() {
    hw = plinth_w / 2;
    hd = plinth_d / 2;
    translate([0, 0, -plinth_h])
        linear_extrude(height = plinth_h)
            polygon([[hw,0],[0,hd],[-hw,0],[0,-hd]]);
}

// --- Render ---
square_base();
faceted_column();

// ============================================
// NOTES:
// - Base: ~55x45mm -> fits 60x50mm box
// - Print vertically (base down)
// - Layer height: 0.2mm, 15% infill is enough
// - No supports needed
// - To adjust the waist: change waist_pos
//   (0.3 = lower, 0.5 = exact center)
// ============================================
