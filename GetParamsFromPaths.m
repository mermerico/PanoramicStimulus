function p = GetParamsFromPaths(filePath)

    [~,name,ext] = fileparts(filePath);
    % Read the file into a Table (first two lines no longer
    % relevant)
    T = readtable(filePath,'Delimiter','\t','HeaderLines',0,'Filetype','text');
    p = table2struct(T);

end