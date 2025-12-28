data = readlines( ...
    "input.txt", ...
    "EmptyLineRule", "skip"...
    );

data = cell2mat(arrayfun(@(x) str2double(strsplit(x, ",")), data, 'UniformOutput', false));

%% PART 1
combs = nchoosek(1:height(data), 2);
n_combs = height(combs);
area = NaN(n_combs, 1);

for i_comb = 1:n_combs
    coord_1 = data(combs(i_comb, 1), :);
    coord_2 = data(combs(i_comb, 2), :);
    area(i_comb) = calc_area(coord_1, coord_2);
end

fprintf("\nPART 1 = %i\n", max(area))

%% PART 2
x_min = min(data(:,1));
x_max = max(data(:,1));
x_transform = @(x) x - x_min + 1;
y_min = min(data(:,2));
y_max = max(data(:,2));
y_transform = @(y) y - y_min + 1;

% TODO(DD): TOO SLOW! NEED INTELLIGENT METHOD INSTEAD

% Create grid normalised to (1,1)
% Mark red or green tiles as true
grid = false(x_transform(x_max), y_transform(y_max));

for i_point = 2:length(data)

    x_prev = x_transform(data(i_point-1, 1));
    y_prev = y_transform(data(i_point-1, 2));

    x = x_transform(data(i_point, 1));
    y = y_transform(data(i_point, 2));

    x_move = min([x, x_prev]) : max([x, x_prev]);
    y_move = min([y, y_prev]) : max([y, y_prev]);
 
    grid(x_move, y_move) = true;
end

% Loop back to first point
% TODO(DD): Functionise
x_prev = x;
y_prev = y;
x = x_transform(data(1, 1));
y = y_transform(data(1, 2));
x_move = min([x, x_prev]) : max([x, x_prev]);
y_move = min([y, y_prev]) : max([y, y_prev]);
grid(x_move, y_move) = true;

% Fill in interior area of green tiles
for i_row = 1:height(grid)
    if ~any(grid(i_row, :))
        continue
    end

    x_first = find(grid(i_row, :), 1, 'first');
    x_last = find(grid(i_row, :), 1, 'last');

    grid(i_row, x_first:x_last) = true;
end

%% Funcs
function area = calc_area(coord_1, coord_2)
    x = abs(coord_1(1) - coord_2(1)) + 1;
    y = abs(coord_1(2) - coord_2(2)) + 1;
    area = x*y;
end