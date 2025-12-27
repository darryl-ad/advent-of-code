data = readlines( ...
    "input.txt", ...
    "EmptyLineRule", "skip"...
    );

n_connect = 1000;

coords = cell2mat(arrayfun(@(x) str2double(strsplit(x, ",")), data, 'UniformOutput', false));
h = height(coords);
IDs = transpose(1:h);

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

% Connect first n
idx_comb = 1;
cntr_connected = 0;
circuits = {};
while cntr_connected < n_connect
    ID_1 = combs(idx_comb, 1);
    ID_2 = combs(idx_comb, 2);

    coord_str_1 = mat2str(coords(ID_1, :));
    coord_str_2 = mat2str(coords(ID_2, :));

    fprintf("\nConnecting...\n    %i:%s\n    %i:%s", ID_1, coord_str_1, ID_2, coord_str_2)

    circuit_idx_1 = find_circuit_match(ID_1, circuits);
    circuit_idx_2 = find_circuit_match(ID_2, circuits);
        
    if isempty(circuit_idx_1) && isempty(circuit_idx_2)
        % New circuit
        circuits{end+1, 1} = [ID_1, ID_2];
        fprintf("\n  New circuit!\n")

    elseif circuit_idx_1 == circuit_idx_2
        % Already connected, skip combination
        fprintf("\n  Already connected!\n")

    elseif isempty(circuit_idx_2)
        % Add ID2 to circuit containing ID1
        circuits{circuit_idx_1, 1} = [circuits{circuit_idx_1, 1}, ID_2];
        fprintf("\n  Added to existing circuit %i!\n", circuit_idx_1)

    elseif isempty(circuit_idx_1)
        % Add ID1 to circuit containing ID2
        circuits{circuit_idx_2, 1} = [circuits{circuit_idx_2, 1}, ID_1];
        fprintf("\n  Added to existing circuit %i!\n", circuit_idx_2)

    else
        % Add circuit containing ID2 to circuit containing ID1, then delete
        % circuit containing ID2
        circuits{circuit_idx_1, 1} = [circuits{circuit_idx_1, 1}, circuits{circuit_idx_2, 1}];
        circuits(circuit_idx_2, :) = [];
        fprintf("\n  Merging circuits %i and %i!\n", circuit_idx_1, circuit_idx_2)

    end

    cntr_connected = cntr_connected + 1;
    idx_comb = idx_comb + 1;

end

[circuits, num_members] = sort_circuits(circuits);

fprintf("\nPART 1 = %i\n", prod(num_members(1:3, :)))


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