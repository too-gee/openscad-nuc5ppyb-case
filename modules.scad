module rounded_cube(
    size,
    radius,
    center
) {
    move = (center == true) ?
        [
            -size[0]/2,
            -size[1]/2,
            -size[2]/2
        ]:[0,0,0];


    translate(v=move)
    union() {
        translate([radius, 0, 0])
        cube(
            size=[
                size[0]-(radius*2),
                size[1],
                size[2]
            ]
        );

        translate([0, radius, 0])
        cube(
            size=[
                size[0],
                size[1]-(radius*2),
                size[2]
            ]
        );

        for(x=[radius, size[0]-radius]) {
            for(y=[radius, size[1]-radius]) {
                translate([x,y,0])
                cylinder(
                    h=size[2],
                    r=radius
                );
            }
        }
    }
}


module usb_port() {
    rotate([90,0,0])
    rounded_cube(
        size=[
            15,
            7.5,
            30
        ],
        radius=0.5,
        center=true
    );
}


module round_port(diameter) {
    rotate([90,0,0])
    cylinder(h=30,d=diameter,center=true);
}


module ethernet_port() {
    rotate([90,0,0])
    rounded_cube(
        size=[
            16,
            14,
            30
        ],
        radius=0.5,
        center=true
    );
}


module hdmi_port() {
    rotate([90,180,0])
    linear_extrude(30)
    polygon(points=[
        [5.306,3.381],
        [5.423,3.370],
        [5.535,3.334],
        [5.637,3.278],
        [7.881,1.721],
        [7.985,1.628],
        [8.065,1.513],
        [8.114,1.382],
        [8.131,1.243],
        [8.131,-2.800],
        [8.111,-2.950],
        [8.053,-3.090],
        [7.961,-3.211],
        [7.840,-3.303],
        [7.700,-3.361],
        [7.550,-3.381],
        [-7.550,-3.381],
        [-7.701,-3.361],
        [-7.841,-3.303],
        [-7.961,-3.211],
        [-8.053,-3.090],
        [-8.112,-2.950],
        [-8.131,-2.800],
        [-8.131,1.243],
        [-8.115,1.382],
        [-8.065,1.513],
        [-7.986,1.628],
        [-7.882,1.721],
        [-5.638,3.278],
        [-5.535,3.334],
        [-5.423,3.370],
        [-5.306,3.381]
    ]);
}


module roundamid(size, height, radius, center) {
    radius = max(radius, height);

    move = (center == true) ?
        [
            -size[0]/2,
            -size[1]/2,
            0
        ]:[0,0,0];

    translate(v=move)
    union() {
        // Filler
        translate([size[0]-radius,0,0])
        rotate([90,0,270])
        mirror([1,0,0])
        linear_extrude(size[0]-(radius*2))
        polygon([
            [0,0],
            [height,height],
            [size[1]-height,height],
            [size[1],0]
        ]);


        // Filler
        translate([0,radius,0])
        rotate([90,0,180])
        mirror([1,0,0])
        linear_extrude(size[1]-(radius*2))
        polygon([
            [0,0],
            [height,height],
            [size[0]-height,height],
            [size[0],0]
        ]);

        // Corners
        for(x=[radius, size[0]-radius]) {
            for(y=[radius, size[1]-radius]) {
                translate([x,y,0])
                cylinder(
                    h=height,
                    r2=radius-height,
                    r1=radius
                );
            }
        }
    }
}


module inset(size, radius, center) {
    move = (center == true) ?
        [
            -size[0]/2,
            0,
            -size[1]/2
        ]:[0,0,0];

    translate(v=move)
    union() {
        // Bottom face
        rotate([45,0,0])
        translate([radius, -40, 0])
        cube(
            size=[
                size[0]-(radius*2),
                40,
                size[1]
            ]
        );

        // Top face
        translate([0,0,size[1]])
        mirror([0,0,1])
        rotate([45,0,0])
        translate([radius, -40, 0])
        cube(
            size=[
                size[0]-(radius*2),
                40,
                size[1]
            ]
        );

        // Side face
        rotate([0,0,-45])
        translate([0, -40, radius])
        cube(
            size=[
                size[0],
                40,
                size[1]-(radius*2)
            ]
        );

        // Side face
        translate([size[0],0,0])
        mirror([1,0,0])
        rotate([0,0,-45])
        translate([0, -40, radius])
        cube(
            size=[
                size[0],
                40,
                size[1]-(radius*2)
            ]
        );

        // Filler
        translate([radius,-30,0])
        cube([
            size[0]-(radius*2),
            30,
            size[1]
        ]);

        // Filler
        translate([0,-30,radius])
        cube([
            size[0],
            30,
            size[1]-(radius*2)
        ]);

        // Corners
        for(x=[radius, size[0]-radius]) {
            for(z=[radius, size[1]-radius]) {
                translate([x,0,z])
                rotate([90,0,0])
                cylinder(
                    h=size[1]+30,
                    r1=radius,
                    r2=radius+size[1]+30
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
            translate([0,0,0])
            cylinder(h=tab_thickness, d=tab_width, center=true);

            // Tab Body
            translate([(tab_width/4),0,chamfer_radius/2])
            cube(size=[tab_width/2,tab_width,tab_thickness+chamfer_radius], center=true);
            
            // Tab Side
            copy_mirror([0,1,0])
            translate([(tab_width-chamfer_radius)/2,-(tab_width+chamfer_radius)/2,chamfer_radius/2])
            cube(size=[chamfer_radius, chamfer_radius, tab_thickness+chamfer_radius], center=true);
        }

        // Tab Side Taper
        copy_mirror([0,1,0])
        translate([(tab_width/2)-chamfer_radius,(tab_width/2)+chamfer_radius,chamfer_radius/2])
        cylinder(h=tab_thickness+chamfer_radius, r=chamfer_radius, center=true);
            
        // Tab Screw Hole
        translate([0,0,chamfer_radius/2])
        cylinder(h=tab_thickness+chamfer_radius, d=tab_hole_diameter, center=true);
        
        // Case Side Chamfer
        translate([(tab_width/2)-chamfer_radius,0,(tab_thickness/2)+chamfer_radius])
        rotate([90,0,0])
        cylinder(h=tab_width*2, r=chamfer_radius,center=true);
        
        // Chamfer Flat Area
        translate([-chamfer_radius,0,(tab_thickness+chamfer_radius)/2])
        cube(size=[tab_width,tab_width*2,chamfer_radius], center=true);
        
        // Screw Flat Area
        translate([0,0,(tab_thickness+chamfer_radius)/2])
        cylinder(h=chamfer_radius, d=tab_width, center=true);
    }
}


module copy_mirror(mirror) {
    children();
    
    mirror(mirror)
    children();
}