use <modules.scad>;

/* [General] */

// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fa,_$fs_and_$fn
// The number of fragments for circles. A bigger number takes longer to render but looks nicer.
$fn = 48; // [0:128]

// Which part to display
which_part = "case"; // ["lid", "case"]

// How thick the walls of the case are (except around ports)
wall_thickness = 3; // [2:20]


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
            tab_thickness = 5;
            tab_hole_diameter = 5;

            translate([
                interior_width/2,
                interior_width/2,
                (tab_thickness/2)-wall_thickness
            ])
            copy_mirror([1,0,0])
            translate([-(interior_width/2)-(tab_width/2)-wall_thickness,0,0])
            mounting_tab(
                tab_width=tab_width,
                tab_thickness=tab_thickness,
                tab_hole_diameter=tab_hole_diameter
            );
        }
        
        difference() {
            union() {
                // Outside Surface
                translate([
                    -wall_thickness,
                    -wall_thickness,
                    -wall_thickness
                ])
                rounded_cube(
                    size=[
                        interior_width + (wall_thickness * 2),
                        interior_width + (wall_thickness * 2),
                        interior_height + wall_thickness
                    ],
                    radius=interior_radius + wall_thickness
                );
            }

            // Interior Cavity
            rounded_cube(
                size=[
                    interior_width,
                    interior_width,
                    interior_height+10
                ],
                radius=interior_radius
            );

            // Front IO Inset
            translate([41.25,-wall_thickness,25.37])
            rotate([90,0,180])
            roundamid(
                size=[50+(wall_thickness*2),22+(wall_thickness*2)],
                height=wall_thickness - inset_wall_thickness,
                radius=wall_thickness + inset_wall_thickness - 1,
                center=true
            );

            // Front USB
            translate([55.5,-14,25.13])
            usb_port();

            // Front Audio
            translate([39,0,20.29])
            round_port(diameter=6);

            // Front IR
            translate([23,0,20.4])
            round_port(diameter=8);

            // Front Power Button
            translate([90.5,0,25])
            round_port(diameter=power_button_diameter);

            // Rear IO Inset
            translate([54,interior_width+wall_thickness,25.37])
            rotate([90,0,0])
            roundamid(
                size=[89+(wall_thickness*2),22+(wall_thickness*2)],
                height=wall_thickness - inset_wall_thickness,
                radius=wall_thickness + inset_wall_thickness - 1,
                center=true
            );

            // Rear USB
            translate([88,122,25.13])
            usb_port();

            // Rear Audio
            translate([29.4,122,19])
            round_port(diameter=7);

            // Rear Power
            translate([15,122,21.9])
            round_port(diameter=9);

            // Rear Ethernet
            translate([69,122,25.5])
            ethernet_port();

            // Rear HDMI
            translate([49,122,20.5])
            hdmi_port();

            // Side IO Inset
            translate([interior_width+wall_thickness,26.8,19])
            rotate([90,0,270])
            roundamid(
                size=[33+(wall_thickness*2),11+(wall_thickness*2)],
                height=wall_thickness - inset_wall_thickness,
                radius=wall_thickness + inset_wall_thickness - 1,
                center=true
            );

            // Side SD
            translate([110,26.8,19])
            rotate([90,0,90])
            rounded_cube(size=[27,5,30], center=true, radius=1);


            if(cable_hole == true) {
                // Side Cable Inset
                translate([-wall_thickness,30,30])
                rotate([90,0,90])
                roundamid(
                    size=[28+(wall_thickness*2)+3,9+(wall_thickness*2)+3],
                    height=wall_thickness - inset_wall_thickness,
                    radius=wall_thickness + inset_wall_thickness - 1,
                    center=true
                );

                // Side Cable Hole
                translate([0,30,30])
                rotate([90,0,90])
                rounded_cube(size=[28,9,30], center=true, radius=1);
            }

            // Fan Exhausts
            for(x = [
                fan_guide_left + ((fan_exhaust_width + fan_guide_width )/ 2)
                :
                actual_exhaust_spacing + fan_exhaust_width
                :
                fan_guide_right
            ]) {
                translate([x,122,6.501])
                rotate([90,0,0])
                rounded_cube(size=[fan_exhaust_width,13,30], radius=3, center=true);
            }
        }

        // Fan Guides
        translate([fan_guide_left,98,5])
        cube([fan_guide_width,20,10], center=true);

        // Fan Guides
        translate([fan_guide_right,98,5])
        cube([fan_guide_width,20,10], center=true);

        // Fan Guides
        translate([
            (fan_guide_right+fan_guide_left)/2,
            88.75,
            1.25
        ])
        cube(
            [
                fan_guide_right-fan_guide_left+fan_guide_width,
                fan_guide_width,
                2.5
            ],
            center=true
        );
        
        // Standoffs
        intersection() {
            rounded_cube(
                size=[
                    interior_width,
                    interior_width,
                    interior_height+10
                ],
                radius=interior_radius
            );
            
            for(x = [5.5, 100.5]) {
                for(y = [8.6, 99.2]) {
                    translate([x, y, standoff_height/2])
                    difference() {
                        direction_x = x < 50 ? -1 : 1;
                        direction_y = y < 50 ? -1 : 1;
                        union() {
                            // Standoff chamfer
                            cylinder(
                                h=standoff_height,
                                r=standoff_radius,
                                center=true
                            );
                            
                            // Standoff filler
                            translate([
                                direction_x * 4 * standoff_radius,
                                direction_y * 5* standoff_radius,
                                0
                            ])
                            cube(
                                size = [
                                    10 * standoff_radius,
                                    10 * standoff_radius,
                                    standoff_height
                                ],
                                center = true
                            );
                            
                            // Standoff filler
                            translate([
                                direction_x * 5 * standoff_radius,
                                direction_y * 4* standoff_radius,
                                0
                            ])
                            cube(
                                size = [
                                    10 * standoff_radius,
                                    10 * standoff_radius,
                                    standoff_height
                                ],
                                center = true
                            );
                        }

                        // Standoff screw hole
                        cylinder(
                            h=standoff_height+1,
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

    vent_area_offset = wall_thickness + lid_thickness;
    vent_area_width = interior_width - (vent_area_offset * 2);
    
    echo(vent_area_width);

    vent_holes_per_row = floor((vent_area_width + min_vent_hole_spacing) / (vent_hole_thickness + min_vent_hole_spacing));
    vent_hole_spacing = (vent_area_width - (vent_holes_per_row * vent_hole_thickness)) / (vent_holes_per_row - 1);

    coords = [
        vent_area_offset + (vent_hole_thickness / 2)
        :
        vent_hole_thickness + vent_hole_spacing
        :
        vent_area_width + vent_area_offset
    ];

    coords_list = [for(i=coords) i];

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
                    size=[
                        interior_width + (wall_thickness * 2),
                        interior_width + (wall_thickness * 2),
                        wall_thickness
                    ],
                    radius=interior_radius + wall_thickness
                );

                // Inside Part
                rounded_cube(
                    size=[
                        interior_width,
                        interior_width,
                        wall_thickness + lid_thickness
                    ],
                    radius=interior_radius
                );

                // Inside Part Bezel
                translate([0,0,wall_thickness + lid_thickness])
                roundamid(
                    size=[interior_width, interior_width],
                    height=2,
                    radius=interior_radius
                );
            }

            for(x=coords) {
                for(y=coords) {
                direction = round((y - coords[0])/coords[1]) % 2;
                    translate([x,y,0])
                    mirror([direction,0,0])
                    vent_hole([vent_hole_thickness,vent_hole_thickness,40+wall_thickness], radius=.5, angle=vent_hole_rotation);
                }
            }

        }
        
        // HDD Mount
        if(hdd_mount == true) {
            tab_thickness = vent_hole_thickness + (2 * vent_hole_spacing);

            translate([interior_width-1.75,coords_list[2],wall_thickness + 22])
            hdd_hook(thickness=tab_thickness);

            translate([interior_width-1.75,coords_list[len(coords_list)-2],wall_thickness + 22])
            hdd_hook(thickness=tab_thickness);

            #translate([interior_width-70.25-36,coords_list[1],wall_thickness + 22])
            rotate([0,0,180])
            hdd_hook(thickness=tab_thickness);

            translate([interior_width-70.25-36,coords_list[len(coords_list)-1],wall_thickness + 22])
            rotate([0,0,180])
            hdd_hook(thickness=tab_thickness);
        }
    }
}