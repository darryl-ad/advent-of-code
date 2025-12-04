data = readlines( ...
    "input.txt", ...
    "EmptyLineRule", "skip"...
    );

h = height(data);
w = strlength(data(1));
rolls = false(h, w);

% Convert to logical for easier downstream processing
data = convertStringsToChars(data);
for idx = 1:h
    rolls(idx, :) = data{idx} == '@';
end

is_accessible = find_accessible(rolls);
total = sum(is_accessible, 'all');

fprintf("PART 1 = %i\n", total)

% Remove rolls, and repeat until no more are accessible
rolls = rolls & ~is_accessible;
is_accessible = find_accessible(rolls);

while any(is_accessible, 'all')
    total = total + sum(is_accessible, 'all');
    rolls = rolls & ~is_accessible;
    is_accessible = find_accessible(rolls);
end

fprintf("PART 2 = %i\n", total)


%% FUNCS

function is_accessible = find_accessible(rolls)

    [h, w] = size(rolls);
    is_accessible = false(h, w);
    for i = 1:h
        for j = 1:w
            if rolls(i, j)
                is_accessible(i,j) = check_accessible(rolls, i, j);
            end
        end
    end

end

function is_accessible = check_accessible(rolls, i, j)

    h = height(rolls);
    w = width(rolls);

    % saturate at edges
    i_min = max([1, i - 1]);
    i_max = min([h, i + 1]);
    j_min = max([1, j - 1]);
    j_max = min([w, j + 1]);

    quadrant = rolls(i_min:i_max, j_min:j_max);
    is_accessible = sum(quadrant, 'all') - rolls(i,j) < 4; % <- don't count the roll in question!
end