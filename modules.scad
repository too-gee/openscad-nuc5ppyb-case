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
        [5.306, 3.381],
        [5.423, 3.370],
        [5.535, 3.334],
        [5.637, 3.278],
        [7.881, 1.721],
        [7.985, 1.628],
        [8.065, 1.513],
        [8.114, 1.382],
        [8.131, 1.243],
        [8.131, -2.800],
        [8.111, -2.950],
        [8.053, -3.090],
        [7.961, -3.211],
        [7.840, -3.303],
        [7.700, -3.361],
        [7.550, -3.381],
        [-7.550, -3.381],
        [-7.701, -3.361],
        [-7.841, -3.303],
        [-7.961, -3.211],
        [-8.053, -3.090],
        [-8.112, -2.950],
        [-8.131, -2.800],
        [-8.131, 1.243],
        [-8.115, 1.382],
        [-8.065, 1.513],
        [-7.986, 1.628],
        [-7.882, 1.721],
        [-5.638, 3.278],
        [-5.535, 3.334],
        [-5.423, 3.370],
        [-5.306, 3.381]
    ]);
}


module hdd_hook(thickness) {
    translate([0, thickness / 2, 0])
    rotate([90, 180, 0])
    linear_extrude(thickness, center = true)
    polygon(points = [
        [-10.500, 8.500],
        [-9.262, 4.578],
        [-9.030, 4.157],
        [-8.672, 3.777],
        [-8.228, 3.502],
        [-7.728, 3.352],
        [-7.206, 3.336],
        [-6.698, 3.456],
        [-2.980, 4.933],
        [-2.472, 5.053],
        [-1.950, 5.037],
        [-1.450, 4.887],
        [-1.006, 4.612],
        [-0.648, 4.232],
        [-0.400, 3.772],
        [0.309, 1.902],
        [0.429, 1.394],
        [0.413, 0.872],
        [0.263, 0.372],
        [-0.012, -0.072],
        [-0.852, -0.677],
        [-4.592, -2.096],
        [-5.052, -2.343],
        [-5.432, -2.701],
        [-5.706, -3.145],
        [-5.857, -3.645],
        [-5.872, -4.167],
        [-5.752, -4.675],
        [-5.436, -5.450],
        [-5.025, -6.442],
        [-4.371, -7.295],
        [-3.519, -7.949],
        [-2.526, -8.360],
        [-1.461, -8.500],
        [2.250, -8.500],
        [3.285, -8.364],
        [4.250, -7.964],
        [5.078, -7.328],
        [5.714, -6.500],
        [6.114, -5.535],
        [6.250, -4.500],
        [6.250, 6.500],
        [7.250, 6.500],
        [9.018, 6.568],
        [9.500, 6.768],
        [9.915, 7.086],
        [10.233, 7.500],
        [10.432, 7.982],
        [10.500, 8.500]
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