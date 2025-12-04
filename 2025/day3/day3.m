data = readlines( ...
    "input.txt", ...
    "EmptyLineRule", "skip"...
    );

n_lines = height(data);
numbers_1 = NaN(n_lines, 1);
numbers_2 = NaN(n_lines, 1);

for i_line = 1:n_lines
    line = data(i_line);
    numbers_1(i_line) = get_biggest_num(line, 2);
    numbers_2(i_line) = get_biggest_num(line, 12);
end

fprintf("\nPart 1: %i\n", sum(numbers_1))
fprintf("\nPart 2: %i\n", sum(numbers_2))


function number = get_biggest_num(x, n)

    % Convert to array of digits
    digits = num2str(x) - '0';

    selected = NaN(n, 1);

    % 1st digit must be the biggest digit up to position [end-n+1], to
    % ensure the final number is n digits long.
    % Remaining digits follow the same pattern, shrinking the search
    % space each time

    pos = 0; % Initialise position state
    for idx = 1:n
        [selected(idx), pos_minor] = max(digits(pos+1 : end-n+idx));

        % Update position relative to the original array of digits
        % pos_minor is the position in the already shrunk array
        pos = pos + pos_minor;
    end

    % Multiply each selected digit by it's corresponding power of 10
    scale = [10.^(n-1:-1:1), 1];
    number = sum(selected(:) .* scale(:));
    
end