use <../mz_get.scad>;

function _get_x(block) = mz_get(block, "x"); 
function _get_y(block) = mz_get(block, "y");
function _get_wall_type(block) = mz_get(block, "w");

function _is_top_wall(block) = _get_wall_type(block) == "TOP_WALL";
function _is_right_wall(block) = _get_wall_type(block) == "RIGHT_WALL";
function _is_top_right_wall(block) = _get_wall_type(block) == "TOP_RIGHT_WALL";

function _cell_position(cell_radius, x_cell, y_cell) =
    let(
        grid_h = 2 * cell_radius * sin(60),
        grid_w = cell_radius + cell_radius * cos(60)
    )
    [grid_w * x_cell, grid_h * y_cell + (x_cell % 2 == 0 ? 0 : grid_h / 2), 0];
    
function _hex_seg(cell_radius, begin, end) = [for(a = [begin:60:end]) 
				[cell_radius * cos(a), cell_radius * sin(a)]];
    
function _top_right(cell_radius) = _hex_seg(cell_radius, 0, 60);
function _top(cell_radius) = _hex_seg(cell_radius, 60, 120);
function _top_left(cell_radius) = _hex_seg(cell_radius, 120, 180);			
function _bottom_left(cell_radius) = _hex_seg(cell_radius, 180, 240); 
function _bottom(cell_radius) = _hex_seg(cell_radius, 240, 300);
function _bottom_right(cell_radius) = _hex_seg(cell_radius, 300, 360); 	   
  
function _right_wall(cell_radius, x_cell) = 
    (x_cell % 2 != 0) ? _bottom_right(cell_radius) : _top_right(cell_radius);

function _row_wall(cell_radius, x_cell, y_cell) =
    x_cell % 2 != 0 ? [_top_right(cell_radius), _top_left(cell_radius)] : [_bottom_right(cell_radius)];
    
function _build_cell(cell_radius, block) = 
    let(
        x = _get_x(block) - 1,
        y = _get_y(block) - 1,
        walls = concat(
            _row_wall(cell_radius, x, y),
            [_is_top_wall(block) || _is_top_right_wall(block) ? _top(cell_radius) : []],
            [_is_right_wall(block) || _is_top_right_wall(block) ? _right_wall(cell_radius, x) : []]
        )
    )
    [
        for(wall = walls)
        if(wall != [])
            [for(p = wall)
                _cell_position(cell_radius, x, y) + p]
    ];
