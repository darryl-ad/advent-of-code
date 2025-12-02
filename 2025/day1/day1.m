
data = readtable( ...
    "input.txt", ...
    "ReadVariableNames", false ...
    );
lines = string(data{:, 1});

% Convert to numeric
lines = strrep(lines, "L", "-");
lines = strrep(lines, "R", "");
nums = str2double(lines);

% Calculate each turn
n_steps = length(nums);
x = NaN(n_steps + 1, 1);
zeros_passed = zeros(n_steps + 1, 1);

x(1) = 50;

for idx = 1:n_steps
    [x(idx+1), zeros_passed(idx+1)] = rotate_dial(x(idx), nums(idx));
end

PART_1 = sum(x == 0)
PART_2 = sum(zeros_passed)

%% FUNCS

function [x_new, n_zeros] = rotate_dial(x_init, n)

    x_new_abs = x_init + n;

    % Discard any multiples of 100, they are a round trip
    x_new = mod(x_new_abs, 100);

    if n == 0
        n_zeros = 0;
        return
    end
    
    if x_new_abs <= 0
        n_zeros = floor(abs(x_new_abs)/100);

        if x_init > 0
            n_zeros = n_zeros + 1;
        end

    elseif x_new_abs >= 100
        n_zeros = floor(x_new_abs/100);

    else
        n_zeros = 0;

    end
    
end