$fn = 128;

mm = 1;
cm = 10*mm;
deg = 1;

// base
base_height = 5*mm;
base_inset = 0.95*mm;
base_outer_radius = 33.45*mm;
base_inner_radius = 33.1*mm;
base_inner_radius_height = 3;
base_torus_radius = 3.25*mm;
base_torus_center = 30.035*mm;

// stepped cone
stepped_cone_step_count = 10;
stepped_cone_total_cone_height = 25*mm;
stepped_cone_step_height = stepped_cone_total_cone_height / stepped_cone_step_count;
stepped_cone_outer_radius = 36.4*mm;
stepped_cone_radial_difference = 8*mm;
stepped_cone_step_width = stepped_cone_radial_difference / stepped_cone_step_count;
stepped_cone_final_radius = stepped_cone_outer_radius - stepped_cone_radial_difference;

// metal mount cylinder
metal_mount_cylinder_radius = 26.8*mm;
metal_mount_cylinder_height = 0.5*mm;
metal_mount_cylinder_vertical_offset = base_height + stepped_cone_total_cone_height;

lower_height = base_height + stepped_cone_total_cone_height + metal_mount_cylinder_height;

// metal upper
metal_upper_outer_radius = 28.3*mm;
metal_upper_wall_thickness = 4.9*mm;
metal_upper_wall_radius = metal_upper_wall_thickness / 2;
metal_upper_wall_center = metal_upper_outer_radius - metal_upper_wall_radius;
metal_upper_inner_radius = metal_upper_outer_radius - metal_upper_wall_thickness;
metal_upper_stickout_height = 21.5*mm;
metal_upper_wall_straight_height = metal_upper_stickout_height - metal_upper_wall_radius;
metal_upper_inner_depth = 43.7*mm - 4*mm; // -4mm to prevent the inside going into the base. this makes 3d printing easier
metal_upper_inner_cylinder_radius = metal_upper_inner_radius + metal_upper_wall_radius;
metal_upper_inner_cylinder_height = metal_upper_inner_depth + metal_upper_wall_thickness - metal_upper_wall_radius;
metal_upper_inside_radius = 8.75*mm;
metal_upper_height = metal_upper_inner_cylinder_height + metal_upper_wall_radius;
metal_upper_hole_depth = metal_upper_height - metal_upper_stickout_height;
metal_upper_hole_offset = lower_height - metal_upper_hole_depth;
handle_connection_x_offset = -67*mm;
handle_connection_z_offset = 17.1*mm;

// handle
handle_outer_width = 11.8*mm;
handle_outer_front_radius = handle_outer_width / 2;
handle_outer_back_radius = 3.15*mm;
handle_inner_width = 6*mm;
handle_inner_radius = handle_inner_width / 2;
handle_front_angle = 18*deg;
handle_back_angle = 7.5*deg;
handle_outer_height = 33.5*mm;
handle_bottom_level_length = 20.75*mm;
handle_bottom_level_length_at_inner_angle = 20.15*mm;
handle_outstep_count = 9;
handle_instep_count = 8;
handle_total_step_count = handle_outstep_count + handle_instep_count;
handle_step_height = handle_outer_height / handle_total_step_count;
handle_connector_bottom_height = 2.5 * handle_step_height * mm;
handle_connector_top_height = (handle_total_step_count - 3.5) * handle_step_height * mm;
handle_connector_height = handle_connector_top_height - handle_connector_bottom_height;
handle_connection_angle = 28.5*deg;


module base_step_alignment_disk() {
  translate([0,0,base_height])
  cylinder(h = 2*mm, r = 4*mm, center = true);
}

module plastic_cup_base() {
  // base
  difference() {
    union() {

      difference() {
        translate([0,0,base_inset])
        cylinder(h = base_height - base_inset, r1 = base_inner_radius, r2 = base_outer_radius);

        cylinder(h = base_inner_radius_height, r = 100, $fn = 6);
      }

      translate([0,0,base_inset])
      cylinder(h = base_height - base_inset, r = base_torus_center);

      difference() {
        translate([0,0,base_torus_radius])
        rotate_extrude(convexity = 10)
        translate([base_torus_center, 0, 0])
        circle(r = base_torus_radius);

        translate([0,0,50 + base_height])
        cube([100,100,100], center = true);
      }

    }

    // #base_step_alignment_disk();
  }
}

module plastic_cup_lower() {


  difference() {
    union() {
      // stepped cone

      translate([0,0,base_height])
      for (i = [0:stepped_cone_step_count-1]) {
        translate([0,0,i*stepped_cone_step_height])
        cylinder(h = stepped_cone_step_height, r = stepped_cone_outer_radius - i*stepped_cone_step_width);
      }



      // metal mount cylinder
      translate([0,0,metal_mount_cylinder_vertical_offset])
      cylinder(h = metal_mount_cylinder_height, r = metal_mount_cylinder_radius);
    }

    translate([0,0,metal_upper_hole_offset])
    cylinder(h = 100, r = metal_upper_inner_cylinder_radius);

    // base_step_alignment_disk();

    plastic_cup_handle();
  }

}

module plastic_cup_handle() {

  difference() {
    translate([handle_connection_x_offset, 0, handle_connection_z_offset])
    rotate([0,handle_connection_angle,0]) {
      // outer steps
      difference() {
        intersection() {
          rotate([0,handle_front_angle,0])
          rotate([0,-handle_back_angle,0])
          union() {
            intersection() {
              rotate([0, handle_back_angle, 0]) {
                translate([handle_outer_front_radius, 0, 0]) {
                  cylinder(h = 100, r = handle_outer_front_radius);
                  translate([0,-handle_outer_front_radius,0])
                  cube([100, handle_outer_width, 100]);
                }
              }

              translate([0,-50,0])
              cube([handle_bottom_level_length_at_inner_angle-handle_outer_back_radius, 100, 100]);
            }

            translate([handle_bottom_level_length_at_inner_angle - 2*handle_outer_back_radius,-(handle_outer_width - 2*handle_outer_back_radius)/2,0])
            cube([2*handle_outer_back_radius, handle_outer_width - 2*handle_outer_back_radius, 100]);

            translate([handle_bottom_level_length_at_inner_angle - handle_outer_back_radius,-(handle_outer_width - 2*handle_outer_back_radius)/2,0])
            cylinder(h = 100, r = handle_outer_back_radius);

            translate([handle_bottom_level_length_at_inner_angle - handle_outer_back_radius,(handle_outer_width - 2*handle_outer_back_radius)/2,0])
            cylinder(h = 100, r = handle_outer_back_radius);
          }

          translate([0,-50,0])
          cube([100,100,handle_outer_height]);
        }

        for (i = [0:handle_instep_count-1]) {
          translate([-50,-50,(2*i + 1)*handle_step_height])
          cube([100,100,handle_step_height]);
        }

      }

      // inner core
      intersection() {
        rotate([0,handle_front_angle,0])
        rotate([0,-handle_back_angle,0])
        intersection() {
          rotate([0, handle_back_angle, 0]) {
            translate([handle_outer_front_radius, 0, 0]) {
              cylinder(h = 100, r = handle_inner_radius);
              translate([0,-handle_inner_radius,0])
              cube([100, handle_inner_width, 100]);
            }
          }



          translate([0,-50,0])
          cube([handle_bottom_level_length_at_inner_angle, 100, 100]);
        }

        translate([0,-50,0])
        cube([100,100,handle_outer_height]);
      }

      // connector
      translate([20,-handle_inner_radius,handle_connector_bottom_height])
      cube([20*mm, handle_inner_width, handle_connector_height]);
    }


    step_exclusion_size = 2*stepped_cone_final_radius + 3;
    translate([0,0,38])
    cube([step_exclusion_size, 20, 20], center = true);

    bottom_exclusion_size = base_height + stepped_cone_step_height;
    translate([0,0,bottom_exclusion_size / 2])
    cube([100,100,bottom_exclusion_size], center = true);

    translate([0,0,metal_upper_hole_offset])
    cylinder(h = 100, r = metal_upper_inner_cylinder_radius + 2);
  }
}

module metal_cup_upper() {

  // main cylinder

  difference() {
    union() {
      translate([0,0,metal_upper_inner_cylinder_height - metal_upper_wall_straight_height])
      cylinder(h = metal_upper_wall_straight_height, r = metal_upper_outer_radius);

      cylinder(h = metal_upper_inner_cylinder_height, r = metal_upper_inner_cylinder_radius);
    }

    translate([0,0,metal_upper_inner_cylinder_height - metal_upper_inner_depth + metal_upper_inside_radius])
    cylinder(r = metal_upper_inner_radius, h = 100);

    translate([0,0,metal_upper_inner_cylinder_height - metal_upper_inner_depth])
    cylinder(r = metal_upper_inner_radius - metal_upper_inside_radius, h = 100);

    translate([0,0,metal_upper_inner_cylinder_height - metal_upper_inner_depth + metal_upper_inside_radius])
    rotate_extrude(convexity = 10)
    translate([metal_upper_inner_radius - metal_upper_inside_radius, 0, 0])
    circle(r = metal_upper_inside_radius);
  }

  translate([0,0,metal_upper_inner_cylinder_height])
  rotate_extrude(convexity = 10)
  translate([metal_upper_wall_center, 0, 0])
  circle(r = metal_upper_wall_radius);
}

saucer_metal_base_inner_diameter = 66*mm;
saucer_metal_base_inner_radius = saucer_metal_base_inner_diameter / 2;
saucer_metal_base_radius_delta = 16.5*mm;
saucer_plastic_base_upper_side_depth_to_center_plastic = 8*mm;
saucer_plastic_base_upper_side_inner_radius = saucer_metal_base_inner_radius + saucer_metal_base_radius_delta;
saucer_plastic_base_upper_side_total_step_radius = 12.8*mm;
saucer_plastic_base_upper_side_step_length = 2*mm;
saucer_plastic_base_upper_side_step_count = 5;
saucer_plastic_base_upper_side_step_and_riser_length = saucer_plastic_base_upper_side_total_step_radius / saucer_plastic_base_upper_side_step_count;
saucer_plastic_base_upper_side_riser_length = saucer_plastic_base_upper_side_step_and_riser_length - saucer_plastic_base_upper_side_step_length;
saucer_plastic_base_upper_side_step_total_height = 6*mm;
saucer_metal_base_height = saucer_plastic_base_upper_side_depth_to_center_plastic - saucer_plastic_base_upper_side_step_total_height;
saucer_metal_base_radius = saucer_metal_base_height/2;
saucer_plastic_base_upper_side_step_height = saucer_plastic_base_upper_side_step_total_height/saucer_plastic_base_upper_side_step_count;
saucer_plastic_base_upper_side_outer_lip_height = 2*mm;
saucer_plastic_base_lower_side_support_ring_outer_diameter = 73*mm;
saucer_plastic_base_lower_side_support_ring_outer_radius = saucer_plastic_base_lower_side_support_ring_outer_diameter / 2;
saucer_plastic_base_lower_side_support_ring_thickness = 2.75*mm;
saucer_plastic_base_lower_side_support_ring_outer_height = 3.3*mm;
saucer_plastic_base_lower_side_support_ring_inner_height = 2.4*mm;
saucer_plastic_base_lower_side_support_ring_inner_radius = saucer_plastic_base_lower_side_support_ring_outer_radius - saucer_plastic_base_lower_side_support_ring_thickness;
saucer_plastic_base_lower_side_radius_of_rounded_edge_at_rise = 2*mm;
saucer_plastic_base_total_height = 12*mm;
saucer_plastic_base_conical_height = saucer_plastic_base_total_height - saucer_plastic_base_lower_side_support_ring_outer_height - saucer_plastic_base_upper_side_outer_lip_height;
saucer_plastic_base_total_radius = saucer_plastic_base_upper_side_inner_radius + saucer_plastic_base_upper_side_total_step_radius; 
saucer_plastic_base_lower_side_conical_angle = 34*deg;
saucer_plastic_base_lower_side_conical_rise_length = saucer_plastic_base_conical_height / tan(saucer_plastic_base_lower_side_conical_angle); // tan(theta) = height/length => length = height/tan(theta)
//saucer_plastic_base_lower_side_radius_at_rise = 50*mm;
saucer_plastic_base_lower_side_radius_at_rise = saucer_plastic_base_total_radius - saucer_plastic_base_lower_side_conical_rise_length;

module plastic_saucer_body_outer_form() {

  // main conical form
  translate([0,0,saucer_plastic_base_lower_side_support_ring_outer_height])
  cylinder(
    r1 = saucer_plastic_base_lower_side_radius_at_rise,
    r2 = saucer_plastic_base_total_radius,
    h = saucer_plastic_base_conical_height
  );

  // outer lip
  translate([
    0,
    0,
    saucer_plastic_base_lower_side_support_ring_outer_height + saucer_plastic_base_conical_height
  ])
  cylinder(
    r = saucer_plastic_base_total_radius,
    h = saucer_plastic_base_upper_side_outer_lip_height
  );

  // support ring

  difference() {
    cylinder(
      h = saucer_plastic_base_lower_side_support_ring_outer_height,
      r = saucer_plastic_base_lower_side_support_ring_outer_radius
    );
    
    translate([0,0,-1*mm])
    cylinder(
      r = saucer_plastic_base_lower_side_support_ring_inner_radius,
      h = 1*mm + saucer_plastic_base_lower_side_support_ring_inner_height
    );
  }

}

module plastic_saucer_body_inner_form() {

  // upper spacer ring to guarantee good subtraction
  translate([
    0,
    0,
    saucer_plastic_base_lower_side_support_ring_outer_height
      + saucer_plastic_base_conical_height
      + saucer_plastic_base_upper_side_outer_lip_height
  ])
  cylinder(
    r = saucer_plastic_base_total_radius - saucer_plastic_base_upper_side_step_length,
    h = 10*mm
  );

  // steps
  for (i = [0:saucer_plastic_base_upper_side_step_count-1]) {
    translate([
      0,
      0,
      saucer_plastic_base_lower_side_support_ring_outer_height
        + saucer_plastic_base_conical_height
        + saucer_plastic_base_upper_side_outer_lip_height
        - saucer_plastic_base_upper_side_step_height
        - i*saucer_plastic_base_upper_side_step_height
    ])
    cylinder(
      r1 = saucer_plastic_base_total_radius
            - (i+1)*saucer_plastic_base_upper_side_step_length
            - (i+1)*saucer_plastic_base_upper_side_riser_length,
      r2 = saucer_plastic_base_total_radius
            - (i+1)*saucer_plastic_base_upper_side_step_length
            - i*saucer_plastic_base_upper_side_riser_length,
      h = saucer_plastic_base_upper_side_step_height
    );
  }

  // disk down to the bottom plastic
  translate([
    0,
    0,
    saucer_plastic_base_lower_side_support_ring_outer_height
      + saucer_plastic_base_conical_height
      + saucer_plastic_base_upper_side_outer_lip_height
      - saucer_plastic_base_upper_side_depth_to_center_plastic
  ])
  cylinder(
    r = saucer_metal_base_inner_radius+saucer_metal_base_radius,
    h = saucer_plastic_base_upper_side_depth_to_center_plastic
  );
}

module plastic_saucer_body() {
  difference() {
    plastic_saucer_body_outer_form();
    plastic_saucer_body_inner_form();
  }
}


// plastic_cup_lower();

// rotate([180,0,0])
// plastic_cup_base();

// base_step_alignment_disk();

// translate([100,0,metal_upper_hole_offset])
// metal_cup_upper();


// plastic_cup_handle();

plastic_saucer_body();

