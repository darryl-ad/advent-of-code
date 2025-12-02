data = readlines( ...
    "input.txt" ...
    );

ranges = strsplit(data(~isempty(data)), ",")';

part_1 = 0;
part_2 = 0;

for i_range = 1:length(ranges)
    
    first = str2double(extractBefore(ranges(i_range), "-"));
    last = str2double(extractAfter(ranges(i_range), "-"));

    for ID = first:1:last
       
        [pass_1, pass_2] = is_repeating(ID);

        if pass_1
            part_1 = part_1 + ID;
        end

        if pass_2
            part_2 = part_2 + ID;
        end
    end
end

fprintf("\nPart 1: %i\n", part_1)
fprintf("\nPart 2: %i\n", part_2)

function [pass_1, pass_2] = is_repeating(x)

    x = num2str(x);
    len = strlength(x);

    pass_1 = false;
    pass_2 = false;

    for n = floor(len/2):-1:1
        % Skip if not divisible by n characters
        if mod(len, n) ~= 0
            continue
        end

        % Split by n characters
        x_split = string(reshape(x, n, [])');

        if all(x_split == x_split(1))
            pass_2 = true;

            if n == len/2
                pass_1 = true;
            end
        end

    end

end