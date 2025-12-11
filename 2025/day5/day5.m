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

%% Determine which ids are within a range
% % First sort ranges by first id
% [~, idx_sort] = sort(ingredient_ranges(:,1), 'ascend');
% ingredient_ranges = ingredient_ranges(idx_sort, :);

is_fresh = NaN(n_ids, 1);
for idx_ids = 1:n_ids
    id = ingredient_ids(idx_ids);
    is_fresh(idx_ids) = any(id >= ingredient_ranges(:,1) & id <= ingredient_ranges(:,2));
end

fprintf("PART 1 = %i\n", sum(is_fresh))