data = readlines( ...
    "input.txt", ...
    "EmptyLineRule", "read"...
    );

idx_break = find(data == "", 1, 'first');
ingredient_ranges_str = data(1:idx_break-1);
ingredient_ids_str = data(idx_break+1:end);
ingredient_ids_str = ingredient_ids_str(ingredient_ids_str~="");

n_ranges = height(ingredient_ranges_str);
n_ids = height(ingredient_ids_str);

%% Convert to numeric for easier downstream processing
ingredient_ranges = NaN(n_ranges, 2);
for idx_range = 1:n_ranges 
    ingredient_ranges(idx_range, :) = str2double( ...
        strsplit(ingredient_ranges_str(idx_range), "-") ...
        );
end

ingredient_ids = str2double(ingredient_ids_str);

%% Determine which IDs are within a range
is_fresh = NaN(n_ids, 1);
for idx_ids = 1:n_ids
    id = ingredient_ids(idx_ids);
    is_fresh(idx_ids) = any(find_range_membership(id, ingredient_ranges(:,1), ingredient_ranges(:,2)));
end

fprintf("PART 1 = %i\n", sum(is_fresh))

%% Determine all possible fresh IDs
% First sort ranges by first id
[~, idx_sort] = sort(ingredient_ranges(:,1), 'ascend');
ingredient_ranges = ingredient_ranges(idx_sort, :);

% Consolidate the ranges into non-overlapping ranges
consolidated_ranges = ingredient_ranges(1, :);

for idx_range = 2:n_ranges

    id_start = ingredient_ranges(idx_range, 1);
    id_end = ingredient_ranges(idx_range, 2);

    % Check if id_start overlaps with any of the consolidated ranges
    overlapped_start = find(find_range_membership(id_start, consolidated_ranges(:,1), consolidated_ranges(:,2)));

    if isempty(overlapped_start)
        % append a new range
        consolidated_ranges = [consolidated_ranges; [id_start, id_end]]; % Accept changing array size, ~1000 rows

    elseif length(overlapped_start) > 1
        error("id_start overlaps with more than 1 consolidated range")

    else
        % Expand existing range end point?
        if id_end <= consolidated_ranges(overlapped_start, 2)
            % Range is already covered. Move on
            continue
        end

        % Expand the consolidated range end point
        consolidated_ranges(overlapped_start, 2) = id_end;

        % Check updated consolidated range boundaries for overlap. 
        for idx = overlapped_start : height(consolidated_ranges) - 1
            if id_end >= consolidated_ranges(idx+1, 1)
                
                % Get new range end id
                id_end = consolidated_ranges(idx+1, 2);

                % Remove unneeded range
                consolidated_ranges(idx+1, :) = [NaN, NaN];

                % Update consolidated range
                consolidated_ranges(overlapped_start, 2) = id_end;
            end
        end
    end
end

fprintf("PART 2 = %i\n", sum(consolidated_ranges(:,2) - consolidated_ranges(:,1) + 1))

function is_in_range = find_range_membership(id, ranges_start, ranges_end)
% Find ranges which id is a member of
    is_in_range = id >= ranges_start & id <= ranges_end;
end