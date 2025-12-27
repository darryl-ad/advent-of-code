data = readlines( ...
    "input.txt", ...
    "EmptyLineRule", "skip"...
    );

coords = cell2mat(arrayfun(@(x) str2double(strsplit(x, ",")), data, 'UniformOutput', false));
IDs = transpose(1:height(coords));

% Pre-calculate all pairwise distance combinations
combs = nchoosek(IDs, 2);
n_combs = length(combs);
distances = NaN(n_combs, 1);
for i_comb = 1:n_combs
    ID_1 = combs(i_comb, 1);
    ID_2 = combs(i_comb, 2);
    distances(i_comb) = get_distance(coords(ID_1, :), coords(ID_2, :));
end

% Sort ascending
[distances, idx_sort] = sort(distances, 'ascend');
combs = combs(idx_sort, :);

% Make connections
cntr_connected = 0;
circuits = num2cell(IDs);
while numel(circuits) > 1
    ID_1 = combs(cntr_connected + 1, 1);
    ID_2 = combs(cntr_connected + 1, 2);

    coord_str_1 = mat2str(coords(ID_1, :));
    coord_str_2 = mat2str(coords(ID_2, :));

    fprintf("\nConnecting...\n    %i:%s\n    %i:%s", ID_1, coord_str_1, ID_2, coord_str_2)

    circuit_idx_1 = find_circuit_match(ID_1, circuits);
    circuit_idx_2 = find_circuit_match(ID_2, circuits);

    if circuit_idx_1 == circuit_idx_2
        % Already connected, skip combination
        fprintf("\n  Already connected!\n")

    else
        % Add circuit containing ID2 to circuit containing ID1, then delete
        % circuit containing ID2
        circuits{circuit_idx_1, 1} = [circuits{circuit_idx_1, 1}, circuits{circuit_idx_2, 1}];
        circuits(circuit_idx_2, :) = [];
        fprintf("\n  Merging circuits %i and %i!\n", circuit_idx_1, circuit_idx_2)

    end

    cntr_connected = cntr_connected + 1;

    if cntr_connected == 1000
        [circuits, num_members] = sort_circuits(circuits);
        part_1 = prod(num_members(1:3, :));
    end

end

fprintf("\nPART 1 = %i\n", part_1)
fprintf("\nPART 2 = %i\n", coords(ID_1, 1) * coords(ID_2, 1))


%% FUNCS
function [circuits, num_members]  = sort_circuits(circuits)
    num_members = cellfun(@(x) numel(x), circuits);
    [num_members, sort_idx] = sort(num_members, 'descend');
    circuits = circuits(sort_idx, 1);
end

function idx = find_circuit_match(ID, circuits)
    idx = find(cellfun(@(x) ismember(ID, x), circuits));
end

function dist = get_distance(xyz_1, xyz_2)
    dist = sqrt( ...
        (xyz_1(1) - xyz_2(1))^2  + ...
        (xyz_1(2) - xyz_2(2))^2 + ...
        (xyz_1(3) - xyz_2(3))^2 ...
    );
end