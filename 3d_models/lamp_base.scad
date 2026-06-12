// ============================================
// Card Holder - Gaudí edition
// Dimensions: 60 x 50 x 40 mm
// Two side slots for sliding cards in
// "Primer l'amor..." quote in relief on front
// ============================================

// --- Main parameters ---
w = 60;          // width (X axis)
d = 50;          // depth (Y axis)
h = 40;          // total height (Z axis)
wall = 2.5;      // wall thickness
slot_w = 2.2;    // slot width (for ~0.8mm card + clearance)
slot_h = 35;     // slot height
slot_depth = 45; // how deep the slot goes (nearly full depth)
text_depth = 0.8;// text relief depth
chamfer = 3;     // top corner chamfer

// --- Main body ---
module body() {
    difference() {
        // Outer box
        cube([w, d, h]);

        // Inner cavity
        translate([wall, wall, wall])
            cube([w - 2*wall, d - 2*wall, h]);

        // Left slot (X=0)
        translate([-0.1, (d - slot_depth) / 2, h - slot_h])
            cube([wall + 0.2, slot_depth, slot_h + 0.1]);

        // Right slot (X=w)
        translate([w - wall - 0.1, (d - slot_depth) / 2, h - slot_h])
            cube([wall + 0.2, slot_depth, slot_h + 0.1]);
    }
}

// --- Relief text (front face, Y=0) ---
module front_text() {
    translate([w/2, text_depth, h * 0.42]) {
        rotate([90, 0, 0]) {
            // Line 1
            translate([0, 6, 0])
            linear_extrude(height = text_depth + 0.1)
                text("Primer l'amor,",
                     size = 5.5,
                     font = "Liberation Sans:style=Bold",
                     halign = "center",
                     valign = "center");
            // Line 2
            translate([0, -1, 0])
            linear_extrude(height = text_depth + 0.1)
                text("despres la tecnica.",
                     size = 5.5,
                     font = "Liberation Sans:style=Bold",
                     halign = "center",
                     valign = "center");
            // Signature
            translate([0, -9, 0])
            linear_extrude(height = text_depth + 0.1)
                text("A.Gaudi",
                     size = 5,
                     font = "Liberation Sans:style=Bold Italic",
                     halign = "center",
                     valign = "center");
        }
    }
}

// --- Final model ---
union() {
    body();
    front_text();
}

// ============================================
// PRINTING NOTES:
// - Orient with base facing down
// - Layer height: 0.15-0.2mm for good text detail
// - If using dual-color filament (multicolor/AMS):
//   text can be printed in red (Z pause at ~1mm)
// - Supports: not needed
// ============================================
