data = readlines( ...
    "input.txt", ...
    "EmptyLineRule", "skip"...
    );

h = height(data) ;
w = strlength(data(1,:));

% Pre-allocate logical arrays for beams and splitters
splitters = false(h, w);
active_splitters = false(h, w);
beams = false(h, w);

% Add first beam from start position
j_start = strfind(data(1), "S");
beams(2, j_start) = true;

for i_row = 3:h-1
    row_data = data(i_row, :);

    % Location of any splitters in row
    j_splitters = strfind(row_data, "^"); 
    splitters(i_row, j_splitters) = true;
    
    % Propogate any split beams
    j_active_splitters = find(splitters(i_row, :) & beams(i_row - 1, :));
    j_split_beams = [j_active_splitters - 1, j_active_splitters + 1];
    active_splitters(i_row, j_active_splitters) = true;

    % Propogate any unsplit beams
    j_unsplit_beams = find(~splitters(i_row, :) & beams(i_row - 1, :));

    % Update beams
    j_beams = unique([j_split_beams, j_unsplit_beams]);
    beams(i_row, j_beams) = true;

end

total_splits = sum(active_splitters, 'all');

fprintf("\nPART 1 = %i\n", total_splits);

%% PART 2
% Use recursion
% Cache solutions (memoization) to make fast enough to solve

global cached_data
cached_data = NaN(h, w);

% TODO(DD): Use memoize built-in??
% memoizedFcn = memoize(@get_new_timelines);
% total_timelines = 1 + memoizedFcn(3, j_start, splitters);

total_timelines = 1 + get_new_timelines(3, j_start, splitters);

fprintf("\nPART 2 = %i\n", total_timelines);

function new_timelines = get_new_timelines(i_beam, j_beam, splitters)

    new_timelines = 0;

    if i_beam >= height(splitters)
        return
    end

    global cached_data
    if ~isnan(cached_data(i_beam, j_beam))
        new_timelines = cached_data(i_beam, j_beam);
        return
    end

    is_split = splitters(i_beam, j_beam);

    if ~is_split
        % No splitting. Keep same beam index and continue to next row
        new_timelines = new_timelines + get_new_timelines(i_beam + 2, j_beam, splitters);

    else
        % Split left and right and start again with remaining rows.
        splits_left = get_new_timelines(i_beam + 2, j_beam - 1, splitters);
        splits_right = get_new_timelines(i_beam + 2, j_beam + 1, splitters);

        new_timelines = new_timelines + 1 + splits_right + splits_left;

    end

    % Update cache with solution
    cached_data(i_beam, j_beam) = new_timelines;     

end