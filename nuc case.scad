use <modules.scad>;

/* [General] */

// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fa,_$fs_and_$fn
// The number of fragments for circles. A bigger number takes longer to render but looks nicer.
$fn = 48; // [0:128]

// Which part to display
which_part = "case"; // ["lid", "case"]

// How thick the walls of the case are (except around ports)
wall_thickness = 3; // [2:20]

// How much additional width should the case have? (This will make the case non-square)
addl_width = 0; // [0:30]


/* [Lid] */

// Should the lid have mounts for a 2.5" hdd?
hdd_mount = true;


/* [Case] */

// Should the case have surface mount tabs?
surface_mount = true;

// Should the case have a side hole for cable passthrough?
cable_hole = true;

// How tall the interior cavity of the case is (including standoffs)
interior_height = 45; // [38:80]

// How thick the exaust ports for the fan are
fan_exhaust_width = 10; // [5:30]

// How much space is between fan exhaust ports (at least)
fan_exhaust_spacing = 2; // [2:15]

// The diameter of the power button hole
power_button_diameter = 13.5; // [0:16]


/* [Hidden] */
interior_width = 108;
interior_radius = 7;
inset_wall_thickness = 1.5;

if(which_part == "case") {
    standoff_radius = 3;
    standoff_hole_size = 1;
    standoff_height=15.2;

    fan_guide_width = 1.5;
    fan_guide_left = 23;
    fan_guide_right = 83;

    fan_guide_gap = fan_guide_right - fan_guide_left - fan_guide_width;
    exhaust_hole_count = floor((fan_guide_gap + fan_exhaust_spacing) / (fan_exhaust_width + fan_exhaust_spacing));
    actual_exhaust_spacing = (fan_guide_gap - (exhaust_hole_count * fan_exhaust_width)) / (exhaust_hole_count - 1);

    render(convexity = 2)
    union() {
        if(surface_mount == true) {
            tab_width = 20;
            hdd_tab_thickness = 5;
            tab_hole_diameter = 5;

            translate([
                (interior_width - addl_width) / 2,
                interior_width / 2,
                (hdd_tab_thickness / 2)- wall_thickness
            ])
            copy_mirror([1, 0, 0])
            translate([-((interior_width + addl_width) / 2) - (tab_width / 2) - wall_thickness, 0, 0])
            mounting_tab(
                tab_width = tab_width,
                tab_thickness = hdd_tab_thickness,
                tab_hole_diameter = tab_hole_diameter
            );
        }
        
        difference() {
            union() {
                // Outside Surface
                translate([
                    -wall_thickness - addl_width,
                    -wall_thickness,
                    -wall_thickness
                ])
                rounded_cube(
                    size = [
                        interior_width + (wall_thickness * 2) + addl_width,
                        interior_width + (wall_thickness * 2),
                        interior_height + wall_thickness
                    ],
                    radius = interior_radius + wall_thickness
                );
            }

            // Interior Cavity
            translate([-addl_width, 0, 0])
            rounded_cube(
                size = [
                    interior_width + addl_width,
                    interior_width,
                    interior_height + 10
                ],
                radius=interior_radius
            );

            // Front IO Inset
            translate([41.25, -wall_thickness, 25.37])
            rotate([90, 0, 180])
            roundamid(
                size = [50 + (wall_thickness * 2), 22 + (wall_thickness * 2)],
                height = wall_thickness - inset_wall_thickness,
                radius = wall_thickness + inset_wall_thickness - 1,
                center = true
            );

            // Front USB
            translate([55.5, -14, 25.13])
            usb_port();

            // Front Audio
            translate([39, -14, 20.29])
            round_port(diameter = 6);

            // Front IR
            translate([23, -14, 20.4])
            round_port(diameter = 8);

            // Front Power Button
            translate([90.5, -14, 25])
            round_port(diameter = power_button_diameter);

            // Rear IO Inset
            translate([54, interior_width + wall_thickness, 25.37])
            rotate([90, 0, 0])
            roundamid(
                size = [89 + (wall_thickness * 2), 22 + (wall_thickness * 2)],
                height = wall_thickness - inset_wall_thickness,
                radius = wall_thickness + inset_wall_thickness - 1,
                center = true
            );

            // Rear USB
            translate([88, 122, 25.13])
            usb_port();

            // Rear Audio
            translate([29.4, 122, 19])
            round_port(diameter = 7);

            // Rear Power
            translate([15, 122, 21.9])
            round_port(diameter = 9);

            // Rear Ethernet
            translate([69, 122, 25.5])
            ethernet_port();

            // Rear HDMI
            translate([49, 122, 20.5])
            hdmi_port();

            // Side IO Inset
            translate([interior_width + wall_thickness, 26.8, 19])
            rotate([90, 0, 270])
            roundamid(
                size = [33 + (wall_thickness * 2), 11 + (wall_thickness * 2)],
                height = wall_thickness - inset_wall_thickness,
                radius = wall_thickness + inset_wall_thickness - 1,
                center = true
            );

            // Side SD
            translate([122, 26.8, 19])
            rotate([90, 0, 90])
            rounded_cube(size=[27, 5, 30], center = true, radius = 1);


            if(cable_hole == true) {
                // Side Cable Inset
                translate([-wall_thickness - addl_width, 30, 30])
                rotate([90, 0, 90])
                roundamid(
                    size = [28 + (wall_thickness * 2) + 3, 9 + (wall_thickness * 2) + 3],
                    height = wall_thickness - inset_wall_thickness,
                    radius = wall_thickness + inset_wall_thickness - 1,
                    center = true
                );

                // Side Cable Hole
                translate([-addl_width, 30, 30])
                rotate([90, 0, 90])
                rounded_cube(size=[28, 9, 30], center = true, radius = 1);
            }

            // Fan Exhausts
            for(x = [
                fan_guide_left + ((fan_exhaust_width + fan_guide_width )/ 2)
                :
                actual_exhaust_spacing + fan_exhaust_width
                :
                fan_guide_right
            ]) {
                translate([x, 122, 6.501])
                rotate([90, 0, 0])
                rounded_cube(size = [fan_exhaust_width, 13, 30], radius = 3, center = true);
            }
        }

        // Fan Guides
        translate([fan_guide_left, 98, 5])
        cube([fan_guide_width, 20, 10], center = true);

        // Fan Guides
        translate([fan_guide_right, 98, 5])
        cube(size = [fan_guide_width, 20, 10], center = true);

        // Fan Guides
        translate([
            (fan_guide_right + fan_guide_left) / 2,
            88.75,
            1.25
        ])
        cube(
            size = [
                fan_guide_right - fan_guide_left + fan_guide_width,
                fan_guide_width,
                2.5
            ],
            center=true
        );
        
        // Standoffs
        intersection() {
            translate([-addl_width, 0, 0])
            rounded_cube(
                size=[
                    interior_width + addl_width,
                    interior_width,
                    interior_height + 10
                ],
                radius = interior_radius
            );
            
            for(x = [5.5, 100.5]) {
                for(y = [8.6, 99.2]) {
                    translate([x, y, standoff_height / 2])
                    difference() {
                        direction_x = x < 50 ? -1 : 1;
                        direction_y = y < 50 ? -1 : 1;
                        union() {
                            // Standoff chamfer
                            cylinder(
                                h = standoff_height,
                                r = standoff_radius,
                                center=true
                            );
                            
                            // Standoff filler
                            translate([
                                (direction_x * 4 * standoff_radius) + (addl_width * direction_x * 0.5),
                                direction_y * 5 * standoff_radius,
                                0
                            ])
                            cube(
                                size = [
                                    (10 * standoff_radius) + addl_width,
                                    10 * standoff_radius,
                                    standoff_height
                                ],
                                center = true
                            );
                            
                            // Standoff filler
                            translate([
                                (direction_x * 5 * standoff_radius) + (addl_width * direction_x * 0.5),
                                direction_y * 4 * standoff_radius,
                                0
                            ])
                            cube(
                                size = [
                                    (10 * standoff_radius) + addl_width,
                                    10 * standoff_radius,
                                    standoff_height
                                ],
                                center = true
                            );
                        }

                        // Standoff screw hole
                        cylinder(
                            h=standoff_height + 1,
                            r=standoff_hole_size,
                            center=true
                        );
                    }
                }
            }
        }
    }
}

if(which_part == "lid") {
    vent_hole_thickness = 5;
    vent_hole_rotation = 45;
    min_vent_hole_spacing = 3;
    
    lid_thickness = 3;
    lid_bevel_thickness = 2;

    vent_area_offset = wall_thickness + lid_thickness;
    vent_area_width = interior_width - (vent_area_offset * 2);

    vent_holes_per_row = floor((vent_area_width + min_vent_hole_spacing) / (vent_hole_thickness + min_vent_hole_spacing));
    vent_hole_spacing = (vent_area_width - (vent_holes_per_row * vent_hole_thickness)) / (vent_holes_per_row - 1);

    hdd_tab_coords = [
        vent_area_offset + (vent_hole_thickness / 2)
        :
        vent_hole_thickness + vent_hole_spacing
        :
        vent_area_width + vent_area_offset
    ];

    hdd_tab_coords_list = [for(i=hdd_tab_coords) i];
        
    hdd_tab_thickness = vent_hole_thickness + (2 * vent_hole_spacing);
    hdd_tab_height = 17;
    hdd_width = 70.5;

    render(convexity = 2)
    union() {
        difference() {
        // Lid Body
            union() {
                // Wide Part
                translate([
                    -wall_thickness,
                    -wall_thickness,
                    0
                ])
                rounded_cube(
                    size = [
                        interior_width + (wall_thickness * 2) + addl_width,
                        interior_width + (wall_thickness * 2),
                        wall_thickness
                    ],
                    radius = interior_radius + wall_thickness
                );

                // Inside Part
                rounded_cube(
                    size = [
                        interior_width + addl_width,
                        interior_width,
                        wall_thickness + lid_thickness
                    ],
                    radius = interior_radius
                );

                // Inside Part Bevel
                translate([0, 0, wall_thickness + lid_thickness])
                roundamid(
                    size = [interior_width + addl_width, interior_width],
                    height = lid_bevel_thickness,
                    radius = interior_radius
                );

                // HDD Mounts
                if(hdd_mount == true) {
                    intersection() {
                        union () {
                            translate([
                                hdd_tab_coords_list[len(hdd_tab_coords_list) - 1],
                                (interior_width + hdd_width) / 2,
                                wall_thickness + lid_bevel_thickness + lid_thickness + (hdd_tab_height / 2)
                            ])
                            rotate([0, 0, 90])
                            hdd_hook(thickness = hdd_tab_thickness);

                            translate([
                                hdd_tab_coords_list[len(hdd_tab_coords_list) - 1],
                                (interior_width - hdd_width) / 2,
                                wall_thickness + lid_bevel_thickness + lid_thickness + (hdd_tab_height / 2)
                            ])
                            rotate([0, 0, -90])
                            hdd_hook(thickness = hdd_tab_thickness);

                            translate([
                                hdd_tab_coords_list[0],
                                (interior_width + hdd_width) / 2,
                                wall_thickness + lid_bevel_thickness + lid_thickness + (hdd_tab_height / 2)
                            ])
                            rotate([0, 0, 90])
                            hdd_hook(thickness = hdd_tab_thickness);

                            translate([
                                hdd_tab_coords_list[0],
                                (interior_width - hdd_width) / 2,
                                wall_thickness + lid_bevel_thickness + lid_thickness + (hdd_tab_height / 2)
                            ])
                            rotate([0, 0, -90])
                            hdd_hook(thickness = hdd_tab_thickness);
                        }
                        
                        // Chop the edges off of the tabs where needed
                        translate([
                            (interior_width + addl_width) / 2,
                            interior_width / 2,
                            (30 + wall_thickness) / 2
                        ])
                        rounded_cube(
                            size = [
                                interior_width - (lid_bevel_thickness * 2) + addl_width,
                                interior_width - (lid_bevel_thickness * 2),
                                30 + wall_thickness
                            ],
                            radius = interior_radius - lid_bevel_thickness,
                            center = true
                        );
                    }
                }
            }

            // Vent Holes
            difference() {
                for(x = hdd_tab_coords) {
                    direction = round((x - hdd_tab_coords[0])/hdd_tab_coords[1]) % 2;

                    for(y = hdd_tab_coords) {
                        union () {
                            translate([x,y,0])
                            rotate([0, 0, 90])
                            mirror([direction,0,0])
                            vent_hole(
                                size = [
                                    vent_hole_thickness,
                                    vent_hole_thickness,
                                    40 + wall_thickness
                                ],
                                radius = 0.5,
                                angle = vent_hole_rotation
                            );
                        }
                    }
                }

                // Remove extra holes from standoffs
                translate([
                    hdd_tab_coords_list[len(hdd_tab_coords_list) - 1],
                    (interior_width + hdd_width) / 2,
                    wall_thickness + lid_bevel_thickness + lid_thickness + (hdd_tab_height / 2)
                ])
                rotate([90,0,90])
                linear_extrude(hdd_tab_thickness, center=true)
                polygon([
                    [-15.250, -6.500],
                    [-15.250, 13.500],
                    [ 14.750, 13.500],
                    [ 14.750,  0.500],
                    [  7.000,  0.500],
                    [  0.000, -6.500]
                ]);

                // Remove extra holes from standoffs
                translate([
                    hdd_tab_coords_list[0],
                    (interior_width - hdd_width) / 2,
                    wall_thickness + lid_bevel_thickness + lid_thickness + (hdd_tab_height / 2)
                ])
                rotate([90,0,-90])
                linear_extrude(hdd_tab_thickness, center=true)
                polygon([
                    [-15.250, -6.500],
                    [-15.250, 13.500],
                    [ 14.750, 13.500],
                    [ 14.750,  0.500],
                    [  7.000,  0.500],
                    [  0.000, -6.500]
                ]);
            }
        }
    }
}

//#translate([62, interior_width / 2, 16.5])
//cube([120, 70, 15], center=true);