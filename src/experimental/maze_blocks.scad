use <experimental/__impl__/_maze_blocks_impl.scad>;

function maze_blocks(start, rows, columns, maze, x_circular = false, y_circular = false) = 
    go_maze( 
        start[0], start[1],   // starting point
        is_undef(maze) ? starting_maze(rows, columns) : maze,  
        rows, columns, x_circular, y_circular
    );
