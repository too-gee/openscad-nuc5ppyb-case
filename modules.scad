module rounded_cube(
    size,
    radius,
    center
) {
    move = (center == true) ?
        [
            -size.x / 2,
            -size.y / 2,
            -size.z / 2
        ]:[0, 0, 0];


    translate(v = move)
    union() {
        translate([radius, 0, 0])
        cube(
            size = [
                size.x - (radius * 2),
                size.y,
                size.z
            ]
        );

        translate([0, radius, 0])
        cube(
            size = [
                size.x,
                size.y - (radius * 2),
                size.z
            ]
        );

        for(x = [radius, size.x - radius]) {
            for(y = [radius, size.y - radius]) {
                translate([x, y, 0])
                cylinder(
                    h = size.z,
                    r = radius
                );
            }
        }
    }
}


module usb_port() {
    rotate([90, 0, 0])
    rounded_cube(
        size = [
            15,
            16,
            30
        ],
        radius = 0.5,
        center = true
    );
}


module round_port(diameter) {
    rotate([90, 0, 0])
    cylinder(h = 30, d = diameter, center = true);
}


module ethernet_port() {
    rotate([90, 0, 0])
    rounded_cube(
        size = [
            16,
            14,
            30
        ],
        radius = 0.5,
        center = true
    );
}


module hdmi_port() {
    rotate([90, 180, 0])
    linear_extrude(30, center = true)
    polygon(points = [
        [ 5.306,  3.381],
        [ 5.423,  3.370],
        [ 5.535,  3.334],
        [ 5.637,  3.278],
        [ 7.881,  1.721],
        [ 7.985,  1.628],
        [ 8.065,  1.513],
        [ 8.114,  1.382],
        [ 8.131,  1.243],
        [ 8.131, -2.800],
        [ 8.111, -2.950],
        [ 8.053, -3.090],
        [ 7.961, -3.211],
        [ 7.840, -3.303],
        [ 7.700, -3.361],
        [ 7.550, -3.381],
        [-7.550, -3.381],
        [-7.701, -3.361],
        [-7.841, -3.303],
        [-7.961, -3.211],
        [-8.053, -3.090],
        [-8.112, -2.950],
        [-8.131, -2.800],
        [-8.131,  1.243],
        [-8.115,  1.382],
        [-8.065,  1.513],
        [-7.986,  1.628],
        [-7.882,  1.721],
        [-5.638,  3.278],
        [-5.535,  3.334],
        [-5.423,  3.370],
        [-5.306,  3.381]
    ]);
}


module hdd_hook(thickness) {
    rotate([90, 180, 0])
    linear_extrude(thickness, center = true)
    polygon(points = [
        [-16.750,  8.500],
        [-15.512,  4.578],
        [-15.280,  4.157],
        [-14.922,  3.777],
        [-14.478,  3.502],
        [-13.978,  3.352],
        [-13.456,  3.336],
        [-12.948,  3.456],
        [ -9.230,  4.933],
        [ -8.722,  5.053],
        [ -8.200,  5.037],
        [ -7.700,  4.887],
        [ -7.256,  4.612],
        [ -6.898,  4.232],
        [ -6.650,  3.772],
        [ -5.941,  1.902],
        [ -5.821,  1.394],
        [ -5.837,  0.872],
        [ -5.987,  0.372],
        [ -6.262, -0.072],
        [ -7.102, -0.677],
        [-10.842, -2.096],
        [-11.302, -2.343],
        [-11.682, -2.701],
        [-11.956, -3.145],
        [-12.107, -3.645],
        [-12.122, -4.167],
        [-12.002, -4.675],
        [-11.686, -5.450],
        [-11.275, -6.442],
        [-10.621, -7.295],
        [ -9.769, -7.949],
        [ -8.776, -8.360],
        [ -7.711, -8.500],
        [ -4.000, -8.500],
        [ -2.965, -8.364],
        [ -2.000, -7.964],
        [ -1.172, -7.328],
        [ -0.536, -6.500],
        [ -0.136, -5.535],
        [  0.000, -4.500],
        [  0.000,  6.500],
        [  1.000,  6.500],
        [  2.768,  6.568],
        [  3.250,  6.768],
        [  3.665,  7.086],
        [  3.983,  7.500],
        [  4.182,  7.982],
        [  4.250,  8.500]
    ]);
}


module roundamid(size, height, radius, center) {
    radius = max(radius, height);

    move = (center == true) ?
        [
            -size.x / 2,
            -size.y / 2,
            0
        ]:[0, 0, 0];

    translate(v = move)
    union() {
        // Filler
        translate([size.x - radius, 0, 0])
        rotate([90, 0, 270])
        mirror([1, 0, 0])
        linear_extrude(size.x - (radius * 2))
        polygon([
            [0, 0],
            [height, height],
            [size.y - height, height],
            [size.y, 0]
        ]);


        // Filler
        translate([0, radius, 0])
        rotate([90, 0, 180])
        mirror([1, 0, 0])
        linear_extrude(size.y - (radius * 2))
        polygon([
            [0, 0],
            [height, height],
            [size.x - height, height],
            [size.x, 0]
        ]);

        // Corners
        for(x = [radius, size.x - radius]) {
            for(y = [radius, size.y - radius]) {
                translate([x, y, 0])
                cylinder(
                    h = height,
                    r2 = radius - height,
                    r1 = radius
                );
            }
        }
    }
}


module inset(size, radius, center) {
    move = (center == true) ?
        [
            -size.x / 2,
            0,
            -size.y / 2
        ]:[0, 0, 0];

    translate(v = move)
    union() {
        // Bottom face
        rotate([45, 0, 0])
        translate([radius, -40, 0])
        cube(
            size = [
                size.x - (radius * 2),
                40,
                size.y
            ]
        );

        // Top face
        translate([0, 0, size.y])
        mirror([0, 0, 1])
        rotate([45, 0, 0])
        translate([radius, -40, 0])
        cube(
            size = [
                size.x - (radius * 2),
                40,
                size.y
            ]
        );

        // Side face
        rotate([0, 0, -45])
        translate([0, -40, radius])
        cube(
            size = [
                size.x,
                40,
                size.y - (radius * 2)
            ]
        );

        // Side face
        translate([size.x, 0, 0])
        mirror([1, 0, 0])
        rotate([0, 0, -45])
        translate([0, -40, radius])
        cube(
            size = [
                size.x,
                40,
                size.y - (radius * 2)
            ]
        );

        // Filler
        translate([radius, -30, 0])
        cube([
            size.x - (radius * 2),
            30,
            size.y
        ]);

        // Filler
        translate([0, -30, radius])
        cube([
            size.x,
            30,
            size.y - (radius * 2)
        ]);

        // Corners
        for(x = [radius, size.x - radius]) {
            for(z = [radius, size.y - radius]) {
                translate([x, 0, z])
                rotate([90, 0, 0])
                cylinder(
                    h = size.y + 30,
                    r1 = radius,
                    r2 = radius + size.y + 30
                );
            }
        }
    }
}


module mounting_tab(tab_width, tab_thickness, tab_hole_diameter) {
    chamfer_radius = 4;

    difference() {
        union() {
            // Tab Radius
            translate([0, 0, 0])
            cylinder(h = tab_thickness, d = tab_width, center = true);

            // Tab Body
            translate([(tab_width / 4), 0, chamfer_radius / 2])
            cube(size = [tab_width / 2, tab_width, tab_thickness + chamfer_radius], center = true);
            
            // Tab Side
            copy_mirror([0, 1, 0])
            translate([(tab_width-chamfer_radius) / 2, - (tab_width + chamfer_radius) / 2, chamfer_radius / 2])
            cube(size = [chamfer_radius, chamfer_radius, tab_thickness + chamfer_radius], center = true);
        }

        // Tab Side Taper
        copy_mirror([0, 1, 0])
        translate([(tab_width / 2) - chamfer_radius, (tab_width / 2) + chamfer_radius, chamfer_radius / 2])
        cylinder(h = tab_thickness + chamfer_radius, r = chamfer_radius, center = true);
            
        // Tab Screw Hole
        translate([0, 0, chamfer_radius / 2])
        cylinder(h = tab_thickness + chamfer_radius, d = tab_hole_diameter, center = true);
        
        // Case Side Chamfer
        translate([(tab_width / 2) - chamfer_radius, 0, (tab_thickness / 2) + chamfer_radius])
        rotate([90, 0, 0])
        cylinder(h = tab_width * 2, r = chamfer_radius, center = true);
        
        // Chamfer Flat Area
        translate([-chamfer_radius, 0, (tab_thickness + chamfer_radius) / 2])
        cube(size = [tab_width, tab_width * 2, chamfer_radius], center = true);
        
        // Screw Flat Area
        translate([0, 0, (tab_thickness + chamfer_radius) / 2])
        cylinder(h = chamfer_radius, d = tab_width, center = true);
    }
}

module mounting_tab_shield(hdd_tab_thickness) {
    rotate([90, 0, 0])
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

module vent_hole(size, radius, angle) {
    corrected_radius = min(size.x / 2, size.y / 2, radius);
    max_dimension = max(size.x, size.y, size.z);

    intersection() {
        translate([0, 0, size.z / 2])
        cube(size = max_dimension, center = true);

        rotate([0, -angle, 0])
        translate([0, 0, size.z / 2])
        linear_extrude(height = size.z * 2, center = true)
        rotate([0, angle, 0])
        union() {
            square([size.x - (corrected_radius * 2), size.y], center = true);
            square([size.x, size.y - (corrected_radius * 2)], center = true);

            copy_mirror([0, 1, 0])
            copy_mirror([1, 0, 0])
            translate([(size.x / 2) - corrected_radius, (size.y / 2) - corrected_radius, 0])
            circle(corrected_radius);
        }
    }
}

module copy_mirror(mirror) {
    children();
    
    mirror(mirror)
    children();
}

function items_per_length(item_size, min_item_spacing, desired_length) = floor((desired_length + min_item_spacing) / (item_size + min_item_spacing));
function actual_item_spacing(item_size, min_item_spacing, desired_length) = (desired_length - (items_per_length(item_size, min_item_spacing, desired_length) * item_size)) / (items_per_length(item_size, min_item_spacing, desired_length) - 1);