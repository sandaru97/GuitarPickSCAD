scale_factor = 55 / 120;

module pick() {
    difference() {
        linear_extrude(height=3.0 * scale_factor * 0.1, scale=1.0) { // Reduced thickness
            offset(r=3 * scale_factor) {
                // Modified polygon with tapered edges
                polygon(points=[ 
                    [0, 0], 
                    [-40 * scale_factor, 50 * scale_factor], 
                    [-70 * scale_factor, 120 * scale_factor], 
                    [70 * scale_factor, 120 * scale_factor], 
                    [40 * scale_factor, 50 * scale_factor]
                ]);
            }
        }
    }

    module add_dots() {
        num_rows = 30;
        row_spacing = (130 * scale_factor) / (num_rows - 1);
        dot_size = 2 * scale_factor; // Diamond's half-width and half-height
        padding = 5 * scale_factor;

        row_start = 6; // Start from the 8th row to skip the top 7

        // Define the text box no-dot area boundaries (only for the top)
        text_box_y_min = 95 * scale_factor - (12.5 * scale_factor + padding);
        text_box_y_max = 95 * scale_factor + (12.5 * scale_factor + padding);
        text_box_x_min = -30 * scale_factor - padding;
        text_box_x_max = 30 * scale_factor + padding;

        for (j = [10 * scale_factor + padding + row_start * row_spacing: row_spacing: 110 * scale_factor + 10 * scale_factor]) {
            num_dots_x = max(1, 15 + round((j - 20 * scale_factor) / (110 * scale_factor - 20 * scale_factor) * 20));
            dot_spacing = 130 * scale_factor / (num_dots_x - 1 + 0.01);

            translate([0, j + -7 * scale_factor, 0]) {
                for (i = [-65 * scale_factor:dot_spacing:65 * scale_factor]) {
                    if (
                        abs(i) < (65 * scale_factor - (110 * scale_factor - j) * 0.6 - padding) &&
                        !(i > text_box_x_min && i < text_box_x_max && j > text_box_y_min && j < text_box_y_max) // Exclude no-dot area ONLY on the top
                    ) {
                        translate([i, 0, 0]) {
                            linear_extrude(height=3.4 * scale_factor) { // Original thickness for dots
                                polygon(points=[
                                    [0, dot_size], 
                                    [-dot_size, 0], 
                                    [0, -dot_size], 
                                    [dot_size, 0]
                                ]);
                            }
                        }
                    }
                }
            }
        }
    }

    // Add the dots at the top and bottom
    translate([0, 5 * scale_factor, 0]) {
        add_dots();
    }

    translate([0, 5 * scale_factor, 3.0 * scale_factor * 0.3]) { // Adjusted Z position for pick thickness
        add_dots();
    }

    // Adjust text position to level it with the dots
    padding = 5 * scale_factor;

    // Adjusting the translation to center text in the no-dot area and level it with dots
    translate([0, 90 * scale_factor, 3.4 * scale_factor]) { // Adjust Z position for original text height
        linear_extrude(height=3.4 * scale_factor) { // Original thickness for text
            translate([0, 0, 0]) { // Ensure text is centered in the padded area
                text("$AM", size=20 * scale_factor, valign="center", halign="center", font="Arial:style=Bold");
            }
        }
    }
}

pick();
