// ============================================================
// Gridfinity Bin for 2 DeWalt Trigger Clamps (Horizontal)
// ============================================================
//
// Drawer-friendly gridfinity bin for DeWalt trigger clamps
// from the DWHT83200D 6-piece set (4.5", 6", 12" sizes).
//
// Clamps lay flat on their side in individual channels.
// Default sized for the 6" medium trigger clamps.
//
// HOW TO USE:
//   1. Open in OpenSCAD
//   2. Select your clamp size from the preset dropdown,
//      or measure your clamps and enter custom values
//   3. Render (F6) and export STL (F7)
//
// IMPORTANT: Measure your own clamps with calipers and adjust
// the dimensions below for a perfect fit. The defaults are
// best-effort estimates for the DWHT83200D set.
//
// Gridfinity spec: 42mm grid pitch, 7mm height unit.
// Prints without supports.
// ============================================================

/* [Clamp Size Preset] */
// Which clamp size from the DWHT83200D set?
clamp_preset = "6in"; // ["4.5in":4.5 inch Small, "6in":6 inch Medium, "12in":12 inch Large, "custom":Custom]

/* [Custom Clamp Dimensions (only used if preset = custom)] */
// Overall length of clamp when fully closed (mm)
custom_clamp_length = 290;
// Handle cross-section height (mm) - the tall dimension of the grip
custom_handle_height = 90;
// Handle cross-section width (mm) - the narrow dimension of the grip
custom_handle_width = 45;
// Handle length along the clamp axis (mm)
custom_handle_length = 130;
// Bar cross-section height (mm)
custom_bar_height = 16;
// Bar cross-section width (mm)
custom_bar_width = 8;

/* [Bin Options] */
// Wall thickness (mm)
wall = 2.0;
// Bottom thickness (mm)
floor_t = 1.2;
// Extra clearance around clamp features (mm)
clearance = 2.0;
// Enable stacking lip on top
stacking_lip = true;
// Number of clamps to hold
num_clamps = 2; // [1:1:4]

/* [Hidden] */
$fn = 48;

// ============================================================
// Clamp Size Presets (DWHT83200D set)
// ============================================================
// Dimensions are estimates - measure yours for best fit!
//
// When a trigger clamp lays on its side:
//   - "height" = the grip profile (trigger to back of handle)
//   - "width"  = across the handle (the thinner axis)
//   - "length" = tip-to-tip along the bar

// 4.5" Small Trigger Clamp
_small_length        = 210;  // overall closed length
_small_handle_height = 60;   // handle profile height
_small_handle_width  = 32;   // handle thickness
_small_handle_length = 100;  // handle portion along bar axis
_small_bar_height    = 12;   // bar profile height (I-beam)
_small_bar_width     = 7;    // bar thickness

// 6" Medium Trigger Clamp
_med_length          = 290;  // overall closed length
_med_handle_height   = 90;   // handle profile height
_med_handle_width    = 45;   // handle thickness
_med_handle_length   = 130;  // handle portion along bar axis
_med_bar_height      = 16;   // bar profile height
_med_bar_width       = 8;    // bar thickness

// 12" Large Trigger Clamp (same handle as 6", longer bar)
_large_length        = 440;  // overall closed length
_large_handle_height = 90;   // handle profile height
_large_handle_width  = 45;   // handle thickness
_large_handle_length = 130;  // handle portion along bar axis
_large_bar_height    = 16;   // bar profile height
_large_bar_width     = 8;    // bar thickness

// Select dimensions based on preset
clamp_length = (clamp_preset == "4.5in") ? _small_length :
               (clamp_preset == "6in")   ? _med_length :
               (clamp_preset == "12in")  ? _large_length :
               custom_clamp_length;

handle_height = (clamp_preset == "4.5in") ? _small_handle_height :
                (clamp_preset == "6in")   ? _med_handle_height :
                (clamp_preset == "12in")  ? _large_handle_height :
                custom_handle_height;

handle_width = (clamp_preset == "4.5in") ? _small_handle_width :
               (clamp_preset == "6in")   ? _med_handle_width :
               (clamp_preset == "12in")  ? _large_handle_width :
               custom_handle_width;

handle_length = (clamp_preset == "4.5in") ? _small_handle_length :
                (clamp_preset == "6in")   ? _med_handle_length :
                (clamp_preset == "12in")  ? _large_handle_length :
                custom_handle_length;

bar_height = (clamp_preset == "4.5in") ? _small_bar_height :
             (clamp_preset == "6in")   ? _med_bar_height :
             (clamp_preset == "12in")  ? _large_bar_height :
             custom_bar_height;

bar_width = (clamp_preset == "4.5in") ? _small_bar_width :
            (clamp_preset == "6in")   ? _med_bar_width :
            (clamp_preset == "12in")  ? _large_bar_width :
            custom_bar_width;

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

// Stacking lip profile height
lip_h = 4.4;

// Height unit
unit_height = 7;

// ============================================================
// Auto-calculate Grid Size
// ============================================================
// Channel dimensions (clamp on its side + clearance)
channel_width  = handle_height + 2 * clearance;  // widest part of clamp profile
channel_length = clamp_length + 2 * clearance;    // full clamp length
channel_depth  = handle_width + clearance;         // how deep the channel is

// Calculate grid units needed (round up to next whole unit)
grid_x = ceil(channel_length / gf_pitch);
grid_y = ceil((num_clamps * channel_width + (num_clamps + 1) * wall) / gf_pitch);
grid_z = ceil((bp_total + floor_t + channel_depth) / unit_height);

// Outer bin dimensions
bin_outer_x = grid_x * gf_pitch - 2 * gf_tol;
bin_outer_y = grid_y * gf_pitch - 2 * gf_tol;

// Total heights
usable_height = grid_z * unit_height;
total_height = usable_height + (stacking_lip ? lip_h : 0);

// Internal depth from top of floor
cavity_depth = usable_height - bp_total - floor_t;

// ============================================================
// Modules
// ============================================================

// Rounded rectangle centered at origin
module rounded_rect(w, d, h, r) {
    actual_r = min(r, min(w, d) / 2 - 0.01);
    linear_extrude(h)
        offset(r = actual_r)
            square([w - 2 * actual_r, d - 2 * actual_r], center = true);
}

// Gridfinity base profile for a single grid unit
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
        translate([0, 0, bp_h1 + bp_h2])
            rounded_rect(unit_size, unit_size, bp_h3, r0);
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

// Stacking lip (simplified stepped rim at top of bin)
module stacking_lip_profile() {
    lip_base = usable_height;
    lip_wall = 1.2;

    translate([0, 0, lip_base]) {
        // Outer lip wall
        difference() {
            rounded_rect(bin_outer_x, bin_outer_y, lip_h, gf_corner);
            translate([0, 0, -0.01])
                rounded_rect(
                    bin_outer_x - 2 * lip_wall,
                    bin_outer_y - 2 * lip_wall,
                    lip_h + 0.02,
                    max(0.5, gf_corner - lip_wall)
                );
        }

        // Step 2: middle ledge
        translate([0, 0, lip_h - bp_h1 - bp_h2]) {
            difference() {
                rounded_rect(
                    bin_outer_x - 2 * 0.4,
                    bin_outer_y - 2 * 0.4,
                    bp_h2, gf_corner - 0.4
                );
                translate([0, 0, -0.01])
                    rounded_rect(
                        bin_outer_x - 2 * lip_wall,
                        bin_outer_y - 2 * lip_wall,
                        bp_h2 + 0.02,
                        max(0.5, gf_corner - lip_wall)
                    );
            }
        }

        // Step 1: top ledge (narrowest)
        translate([0, 0, lip_h - bp_h1]) {
            difference() {
                rounded_rect(
                    bin_outer_x - 2 * 0.8,
                    bin_outer_y - 2 * 0.8,
                    bp_h1, gf_corner - 0.8
                );
                translate([0, 0, -0.01])
                    rounded_rect(
                        bin_outer_x - 2 * lip_wall,
                        bin_outer_y - 2 * lip_wall,
                        bp_h1 + 0.02,
                        max(0.5, gf_corner - lip_wall)
                    );
            }
        }
    }
}

// Main bin body
module bin_body() {
    translate([0, 0, bp_total])
        rounded_rect(
            bin_outer_x,
            bin_outer_y,
            usable_height - bp_total,
            gf_corner
        );
}

// A single clamp channel (horizontal trough for clamp on its side)
// The channel has a wider handle section and narrower bar section.
module clamp_channel() {
    fillet_r = 2;
    bar_channel_width = bar_height + 2 * clearance;

    // Handle section: wider rectangular trough on one end
    translate([-(channel_length / 2) + clearance, 0, 0])
        rounded_rect(
            handle_length + clearance,
            channel_width,
            cavity_depth + 0.02,
            fillet_r
        );

    // Bar section: narrower trough extending the full length
    rounded_rect(
        channel_length,
        bar_channel_width,
        cavity_depth + 0.02,
        fillet_r
    );

    // Tapered transition from handle to bar (for printability)
    transition_len = 15;
    translate([-(channel_length / 2) + clearance + handle_length + transition_len / 2, 0, 0])
        hull() {
            translate([-transition_len / 2, 0, 0])
                rounded_rect(0.01, channel_width, cavity_depth + 0.02, fillet_r);
            translate([transition_len / 2, 0, 0])
                rounded_rect(0.01, bar_channel_width, cavity_depth + 0.02, fillet_r);
        }
}

// ============================================================
// Assembly
// ============================================================
module gridfinity_clamp_bin() {
    // Y positions for each clamp channel (evenly spaced)
    total_channels_width = num_clamps * channel_width;
    total_gaps = bin_outer_y - 2 * wall - total_channels_width;
    gap = total_gaps / (num_clamps + 1);

    // Floor Z
    pocket_z = bp_total + floor_t;

    difference() {
        union() {
            base_profile();
            bin_body();
            if (stacking_lip)
                stacking_lip_profile();
        }

        // Cut channels for each clamp
        for (i = [0 : num_clamps - 1]) {
            cy = -bin_outer_y / 2 + wall + gap + channel_width / 2
                 + i * (channel_width + gap);
            translate([0, cy, pocket_z])
                clamp_channel();
        }
    }
}

// ============================================================
// Info echo
// ============================================================
echo(str("=== Gridfinity DeWalt Clamp Bin ==="));
echo(str("Clamp preset: ", clamp_preset));
echo(str("Grid size: ", grid_x, " x ", grid_y, " (", bin_outer_x, "mm x ", bin_outer_y, "mm)"));
echo(str("Height: ", grid_z, " units (", usable_height, "mm", stacking_lip ? str(" + ", lip_h, "mm lip") : "", ")"));
echo(str("Channel: ", channel_length, "mm long x ", channel_width, "mm wide x ", cavity_depth, "mm deep"));
echo(str("Holds: ", num_clamps, " clamp(s) laying flat"));

// ============================================================
// Render
// ============================================================
gridfinity_clamp_bin();
