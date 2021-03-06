use <_impl/_mz_blocks_impl.scad>;
use <mz_initialize.scad>;

function mz_blocks(start, rows, columns, maze, x_circular = false, y_circular = false, seed) = 
    go_maze( 
        start[0], start[1],   // starting point
        is_undef(maze) ? mz_initialize(rows, columns) : maze,  
        rows, columns, x_circular, y_circular, seed
    );
