// ============================================================
// Gridfinity Bin for 2 DeWalt Squeeze Clamps
// ============================================================
//
// A gridfinity-compatible bin with two shaped pockets for
// DeWalt 6" trigger/squeeze clamps (e.g. DWHT83148, DWHT83192).
// Clamps sit handle-down with the bar extending upward.
//
// Gridfinity spec: 42mm grid pitch, 7mm height unit.
// Designed to print without supports.
// ============================================================

/* [Grid Size] */
// Number of grid units along X
grid_x = 2; // [1:1:6]
// Number of grid units along Y
grid_y = 2; // [1:1:6]
// Number of height units (7mm each)
grid_z = 5; // [1:1:10]

/* [Clamp Dimensions] */
// Handle width (mm) - measured across the grip
clamp_handle_w = 40;
// Handle depth (mm) - front to back
clamp_handle_d = 50;
// Bar width (mm) - the sliding bar cross-section width
clamp_bar_w = 10;
// Bar depth (mm) - the sliding bar cross-section depth
clamp_bar_d = 18;
// Extra clearance around all clamp features (mm)
clamp_clearance = 1.5;

/* [Bin Options] */
// Wall thickness (mm)
wall = 2.0;
// Bottom thickness (mm)
floor_t = 1.2;
// Corner chamfer on pockets (mm)
pocket_chamfer = 3;
// Enable stacking lip
stacking_lip = true;
// Enable scoop in front of each pocket
enable_scoop = true;

/* [Hidden] */
$fn = 48;

// ============================================================
// Gridfinity Standard Dimensions
// ============================================================
gf_pitch  = 42;      // grid pitch (mm)
gf_tol    = 0.25;    // clearance per side (mm)
gf_corner = 3.75;    // bin corner radius (mm)

// Base profile step heights (bottom-up)
bp_h1 = 0.8;         // first step height
bp_h2 = 1.8;         // second step height
bp_h3 = 2.15;        // third step height
bp_total = bp_h1 + bp_h2 + bp_h3; // 4.75mm

// Stacking lip profile
lip_h = 4.4;          // stacking lip added height

// ============================================================
// Derived Dimensions
// ============================================================
bin_outer_x = grid_x * gf_pitch - 2 * gf_tol;
bin_outer_y = grid_y * gf_pitch - 2 * gf_tol;

// Total bin height: base profile + usable height + stacking lip
unit_height = 7;
usable_height = grid_z * unit_height;
total_height = usable_height + (stacking_lip ? lip_h : 0);

// Internal cavity depth (from top of floor to top of bin wall)
cavity_depth = usable_height - bp_total - floor_t;

// Pocket dimensions with clearance
pocket_w = clamp_handle_w + 2 * clamp_clearance;
pocket_d = clamp_handle_d + 2 * clamp_clearance;
slot_w   = clamp_bar_w + 2 * clamp_clearance;
slot_d   = clamp_bar_d + 2 * clamp_clearance;

// ============================================================
// Modules
// ============================================================

// Rounded rectangle centered at origin
module rounded_rect(w, d, h, r) {
    linear_extrude(h)
        offset(r = r)
            square([w - 2*r, d - 2*r], center = true);
}

// Gridfinity base profile for a single grid unit
// Produces the stair-stepped profile at the base
module base_profile_unit(x_off, y_off) {
    unit_size = gf_pitch - 2 * gf_tol;
    r0 = gf_corner;

    translate([x_off, y_off, 0]) {
        // Step 1: bottom (narrowest)
        r1 = r0 - 0.8;
        s1 = unit_size - 2 * 0.8;
        rounded_rect(s1, s1, bp_h1, r1);

        // Step 2: middle
        translate([0, 0, bp_h1]) {
            r2 = r0 - 0.4;
            s2 = unit_size - 2 * 0.4;
            rounded_rect(s2, s2, bp_h2, r2);
        }

        // Step 3: top (widest, matches bin wall)
        translate([0, 0, bp_h1 + bp_h2]) {
            rounded_rect(unit_size, unit_size, bp_h3, r0);
        }
    }
}

// Full base profile for all grid units
module base_profile() {
    for (ix = [0 : grid_x - 1])
        for (iy = [0 : grid_y - 1]) {
            cx = (ix - (grid_x - 1) / 2) * gf_pitch;
            cy = (iy - (grid_y - 1) / 2) * gf_pitch;
            base_profile_unit(cx, cy);
        }
}

// Stacking lip profile (inverted base profile at the top)
module stacking_lip_profile() {
    lip_base = usable_height;

    translate([0, 0, lip_base]) {
        // The stacking lip mirrors the base profile geometry
        // so another bin can stack on top

        // Main lip wall (vertical portion)
        difference() {
            rounded_rect(bin_outer_x, bin_outer_y, lip_h, gf_corner);

            // Hollow out the inside, leaving just the lip wall
            translate([0, 0, -0.01])
                rounded_rect(
                    bin_outer_x - 2 * 1.2,
                    bin_outer_y - 2 * 1.2,
                    lip_h + 0.02,
                    gf_corner - 1.2
                );
        }

        // Step 1: top ledge (narrowest, at the very top)
        translate([0, 0, lip_h - bp_h1]) {
            difference() {
                r1 = gf_corner - 0.8;
                s1x = bin_outer_x - 2 * 0.8;
                s1y = bin_outer_y - 2 * 0.8;
                rounded_rect(s1x, s1y, bp_h1, r1);
                translate([0, 0, -0.01])
                    rounded_rect(
                        bin_outer_x - 2 * 1.2,
                        bin_outer_y - 2 * 1.2,
                        bp_h1 + 0.02,
                        gf_corner - 1.2
                    );
            }
        }

        // Step 2: middle ledge
        translate([0, 0, lip_h - bp_h1 - bp_h2]) {
            difference() {
                r2 = gf_corner - 0.4;
                s2x = bin_outer_x - 2 * 0.4;
                s2y = bin_outer_y - 2 * 0.4;
                rounded_rect(s2x, s2y, bp_h2, r2);
                translate([0, 0, -0.01])
                    rounded_rect(
                        bin_outer_x - 2 * 1.2,
                        bin_outer_y - 2 * 1.2,
                        bp_h2 + 0.02,
                        gf_corner - 1.2
                    );
            }
        }
    }
}

// A single clamp pocket (handle + bar slot)
module clamp_pocket() {
    // Handle pocket - rounded rectangle
    chamfered_pocket_w = pocket_w;
    chamfered_pocket_d = pocket_d;

    // Full-depth handle pocket
    translate([0, 0, -0.01])
        rounded_rect(
            chamfered_pocket_w,
            chamfered_pocket_d,
            cavity_depth + 0.02,
            pocket_chamfer
        );

    // Bar slot - narrower channel extending the full height
    // This lets the bar slide through even if bin is stacked
    translate([0, 0, -0.01])
        rounded_rect(
            slot_w,
            slot_d,
            total_height + 1,
            min(slot_w, slot_d) / 4
        );
}

// Scoop ramp to help grab clamps
module scoop(pocket_w_local, depth) {
    scoop_r = depth * 0.7;
    translate([0, -pocket_w_local/2 + scoop_r * 0.1, 0])
        rotate([0, 90, 0])
            translate([0, 0, -pocket_w_local/2])
                intersection() {
                    cylinder(r = scoop_r, h = pocket_w_local);
                    translate([-scoop_r, 0, 0])
                        cube([scoop_r, scoop_r, pocket_w_local]);
                }
}

// Main bin body (outer shell)
module bin_body() {
    // Main bin walls from top of base profile to full height
    translate([0, 0, bp_total])
        rounded_rect(
            bin_outer_x,
            bin_outer_y,
            usable_height - bp_total,
            gf_corner
        );
}

// ============================================================
// Assembly
// ============================================================
module gridfinity_clamp_bin() {
    // Spacing between the two clamp pockets
    pocket_spacing = bin_outer_x / 2;
    pocket_x1 = -pocket_spacing / 2;
    pocket_x2 =  pocket_spacing / 2;

    // Y position: center pockets in the bin
    pocket_y = 0;

    // Z position: top of floor
    pocket_z = bp_total + floor_t;

    difference() {
        union() {
            // Gridfinity base profile
            base_profile();

            // Bin body
            bin_body();

            // Stacking lip
            if (stacking_lip) {
                stacking_lip_profile();
            }
        }

        // Cut the two clamp pockets
        for (px = [pocket_x1, pocket_x2]) {
            translate([px, pocket_y, pocket_z])
                clamp_pocket();
        }

        // Scoop cuts for easier clamp removal
        if (enable_scoop) {
            for (px = [pocket_x1, pocket_x2]) {
                translate([px, -bin_outer_y/2 + wall, pocket_z])
                    scoop(pocket_w, cavity_depth);
            }
        }
    }
}

// ============================================================
// Render
// ============================================================
gridfinity_clamp_bin();
