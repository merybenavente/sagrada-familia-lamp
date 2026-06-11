// ============================================
// Card Holder - Gaudí edition
// Medidas: 60 x 50 x 40 mm
// Dos ranuras laterales para deslizar tarjetas
// Texto "Primer l'amor..." en relieve frontal
// ============================================

// --- Parámetros principales ---
w = 60;          // ancho (eje X)
d = 50;          // profundidad (eje Y)
h = 40;          // altura total (eje Z)
wall = 2.5;      // grosor de pared
slot_w = 2.2;    // ancho de ranura (para tarjeta ~0.8mm + holgura)
slot_h = 35;     // altura de ranura
slot_depth = 45; // cuánto entra la ranura (casi toda la profundidad)
text_depth = 0.8;// profundidad del relieve de texto
chamfer = 3;     // chaflán de esquinas superiores

// --- Cuerpo principal ---
module body() {
    difference() {
        // Caja exterior
        cube([w, d, h]);
        
        // Vaciado interior
        translate([wall, wall, wall])
            cube([w - 2*wall, d - 2*wall, h]);
        
        // Ranura lado izquierdo (X=0)
        translate([-0.1, (d - slot_depth) / 2, h - slot_h])
            cube([wall + 0.2, slot_depth, slot_h + 0.1]);
        
        // Ranura lado derecho (X=w)
        translate([w - wall - 0.1, (d - slot_depth) / 2, h - slot_h])
            cube([wall + 0.2, slot_depth, slot_h + 0.1]);
    }
}

// --- Texto en relieve (cara frontal, Y=0) ---
module front_text() {
    translate([w/2, text_depth, h * 0.42]) {
        rotate([90, 0, 0]) {
            // Línea 1
            translate([0, 6, 0])
            linear_extrude(height = text_depth + 0.1)
                text("Primer l'amor,", 
                     size = 5.5, 
                     font = "Liberation Sans:style=Bold",
                     halign = "center", 
                     valign = "center");
            // Línea 2
            translate([0, -1, 0])
            linear_extrude(height = text_depth + 0.1)
                text("despres la tecnica.", 
                     size = 5.5, 
                     font = "Liberation Sans:style=Bold",
                     halign = "center", 
                     valign = "center");
            // Firma
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

// --- Modelo final ---
union() {
    body();
    front_text();
}

// ============================================
// NOTAS PARA IMPRIMIR:
// - Orientar con la base hacia abajo
// - Layer height: 0.15-0.2mm para buen detalle en texto
// - Si usas filamento de dos colores (multicolor/AMS):
//   el texto puede imprimirse en rojo (pausa en Z ~1mm)
// - Soportes: no necesarios
// ============================================
