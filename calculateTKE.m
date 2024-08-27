function TKE = calculateTKE(uField, vField, wField)
    % Validate input arguments
    if ~iscell(uField) || ~iscell(vField) || ~iscell(wField)
        error('Input arguments must be cell arrays.');
    end

    % Get the dimensions of the cell arrays
    numCells = numel(uField);
    
    % Assume each cell contains matrices of the same size
    field = uField{1};
    field = cell2mat(field);
    [rows, cols, pa] = size(field);
    
    % Preallocate matrices to store the data
    uFieldMat = zeros(rows, cols, pa, numCells);
    vFieldMat = zeros(rows, cols, pa, numCells);
    wFieldMat = zeros(rows, cols, pa, numCells);

    % Convert cell arrays to matrices using a loop
    for t = 1:numCells
        u = cell2mat(uField{t});
        v = cell2mat(vField{t});
        w = cell2mat(wField{t});

        if isnumeric(u) && isnumeric(v) && isnumeric(w)
            uFieldMat(:,:,:,t) = u;
            vFieldMat(:,:,:,t) = v;
            wFieldMat(:,:,:,t) = w;
        else
            error('Each cell must contain numeric data.');
        end
    end

    % Calculate the mean velocities across all dimensions
    meanU = mean(uFieldMat, 'all');
    meanV = mean(vFieldMat, 'all');
    meanW = mean(wFieldMat, 'all');

    % Calculate the velocity fluctuations
    uPrime = uFieldMat - meanU;
    vPrime = vFieldMat - meanV;
    wPrime = wFieldMat - meanW;

    % Calculate the squared fluctuations
    uPrimeSquared = uPrime.^2;
    vPrimeSquared = vPrime.^2;
    wPrimeSquared = wPrime.^2;

    % Calculate the mean of the squared fluctuations
    meanUPrimeSquared = mean(uPrimeSquared, 'all');
    meanVPrimeSquared = mean(vPrimeSquared, 'all');
    meanWPrimeSquared = mean(wPrimeSquared, 'all');

    % Calculate TKE for the whole system
    TKE = 0.5 * (meanUPrimeSquared + meanVPrimeSquared + meanWPrimeSquared);
end
