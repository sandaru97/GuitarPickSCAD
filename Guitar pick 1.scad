module pick() {
  // Define the pick shape with a sharper tip and wider base
  difference() {
    linear_extrude(height=2) {
      offset(r=5) {  // Reduced roundness for a more typical bass pick shape
        // Define the polygon for a bass pick shape
        polygon(points=[[0,0],[-70,110],[70,110]]);
      }
    }
  }

  // Function to create dots on one side
  module add_dots() {
    num_rows = 10;  // Number of rows
    row_spacing = (110 - 63) / (num_rows - 1);  // Calculate spacing between rows

    dot_radius = 2;  // Increased radius of dots

    for (j = [63: row_spacing: 110]) {  // Loop for y-axis rows
      // Default number of dots along x-axis
      num_dots_x = 15;
      
      // Increase number of dots in the middle columns to cover more area
      if (abs(j - 81.5) < 15) {  // Adjust range for middle columns
        num_dots_x = 25;  // More dots in middle columns
      }
      
      dot_spacing = 140 / (num_dots_x - 1);  // Set spacing between dots

      translate([0, j, 0]) {
        for (i = [-70:dot_spacing:70]) {  // Adjust range to match spacing
          if (abs(i) < (70 - (110 - j))) {  // Ensure dots fit within the pick's shape
            translate([i, 0, 0]) {
              // Create each dot with the new radius and ensure a gap
              cylinder(h=2.3, r=dot_radius, center=true);  // Adjusted radius
            }
          }
        }
      }
    }
  }

  // Create dots on the front side
  add_dots();

  // Create dots on the back side
  translate([0, 0, 2]) {  // Translate 2 mm to the opposite side
    add_dots();
  }
}

// Call the pick() module
pick();
