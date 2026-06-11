// ============================================
// Columna facetada - estilo Gaudí
// Alto: 240mm, encaja en base de 60x50mm
// Sólida, con cintura, facetas triangulares
// ============================================

// --- Parámetros ---
total_h     = 240;   // altura total
base_w      = 55;    // ancho base (encaja en caja 60mm con holgura)
base_d      = 45;    // profundidad base (encaja en caja 50mm con holgura)
top_w       = 40;    // ancho arriba
top_d       = 33;    // profundidad arriba
waist_w     = 28;    // ancho en la cintura (punto más estrecho)
waist_d     = 23;    // profundidad en la cintura
waist_pos   = 0.42;  // posición de la cintura (0=base, 1=top)
facets      = 6;     // número de facetas por lado (más = más suave)

// --- Perfil de la columna con cintura ---
// Usamos una serie de secciones interpoladas
// y las facetamos rotando polígonos

module faceted_column() {
    // Número de secciones verticales
    sections = 24;
    
    // Función para interpolar con curva suave (ease in-out)
    function smooth(t) = t * t * (3 - 2 * t);
    
    // Interpolación del perfil con cintura
    function profile_w(t) = 
        t <= waist_pos 
            ? base_w + (waist_w - base_w) * smooth(t / waist_pos)
            : waist_w + (top_w - waist_w) * smooth((t - waist_pos) / (1 - waist_pos));
    
    function profile_d(t) = 
        t <= waist_pos 
            ? base_d + (waist_d - base_d) * smooth(t / waist_pos)
            : waist_d + (top_d - waist_d) * smooth((t - waist_pos) / (1 - waist_pos));

    // Construimos con hull entre secciones facetadas
    for (i = [0 : sections - 1]) {
        t0 = i / sections;
        t1 = (i + 1) / sections;
        z0 = t0 * total_h;
        z1 = t1 * total_h;
        w0 = profile_w(t0) / 2;
        d0 = profile_d(t0) / 2;
        w1 = profile_w(t1) / 2;
        d1 = profile_d(t1) / 2;
        
        // Rotación alternada para el efecto de diamante/faceta
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

// --- Render ---
faceted_column();

// ============================================
// NOTAS:
// - Base: ~55x45mm → encaja en caja 60x50mm
// - Imprimir vertical (base abajo)
// - Layer height: 0.2mm, infill 15% suficiente
// - No necesita soportes
// - Si quieres ajustar la cintura: cambia waist_pos
//   (0.3 = más abajo, 0.5 = centro exacto)
// ============================================
