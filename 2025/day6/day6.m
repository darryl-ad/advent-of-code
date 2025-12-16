data = readlines( ...
    "input.txt", ...
    "EmptyLineRule", "skip"...
    );

h_numbers = height(data) - 1;
w_numbers = numel(strsplit(strip(data(1)), " "));

% Extract arrays of data
ops = strsplit(strip(data(end, :)), " ");
numbers = NaN(h_numbers, w_numbers);
for i_row = 1:h_numbers
    numbers(i_row, :) = str2double(strsplit(strip(data(i_row, :)), " "));
end

%% PART 1
results = NaN(1, w_numbers);
for i_calc = 1:w_numbers
    results(i_calc) = perform_calc(numbers(:, i_calc), ops(i_calc));
end

fprintf("PART 1 = %i\n", sum(results))

%% PART 2
% Read data as characters
numbers_chars = convertStringsToChars(data(1:end-1, :));

% Loop right to left, concatenating char columns
w_chars = numel(numbers_chars{1, :});

results_2 = NaN(1, w_numbers);
problem_numbers = [];

cntr_op = 1;
for idx_char = w_chars:-1:1
    
    this_col = cellfun(@(x) x(idx_char), numbers_chars);

    if all(this_col == ' ')
        % Empty column, perform calc on previous numbers and add to total
        this_op = ops(end - cntr_op + 1);
        results_2(cntr_op) = perform_calc(problem_numbers, this_op);

        % Re-initialise stored numbers and update cntr
        problem_numbers = [];
        cntr_op = cntr_op + 1;

    else
       % Contains number, store it until time to calculate
       problem_numbers(end + 1) = str2double(this_col'); % Accept appending rather than pre-allocating

    end

    % If the final column is not empty, sum up what we have left
    if idx_char == 1 && ~all(this_col == ' ')
        this_op = ops(end - cntr_op + 1);
        results_2(cntr_op) = perform_calc(problem_numbers, this_op);
    end

end

fprintf("PART 1 = %i\n", sum(results_2))


%% FUNCS
function result = perform_calc(numbers, op)
    
    if op == "+"
        result = sum(numbers);
    elseif op == "*"
        result = prod(numbers);
    else
        error("Unexpected op - '%s'", op)
    end

end