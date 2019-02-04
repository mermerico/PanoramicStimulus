function p = GetParamsFromPaths(filePath)

    [~,name,ext] = fileparts(filePath);
    switch ext
        case '.txt'
            % Read the file into a Table (first two lines no longer
            % relevant)
            T = readtable(filePath,'Delimiter','\t','ReadVariableNames',false,'HeaderLines',0);
            Nepochs = width(T)-1;
            Nparams = height(T);
            Stimulus = [];
            for jj=1:Nepochs
                for ii=1:Nparams
%                     eval([T{ii,1}{1} '= T{ii,1+jj};']);
                    if isnumeric(T{ii,1+jj}) %Entire column was numeric, so it stayed numeric
                        eval([T{ii,1}{1} '= T{ii,1+jj};'])
                    else %At least one row was a string, convert all others back to numerics
                       [value,wasConverted] = str2num(T{ii,1+jj}{1});
                        if wasConverted
                            eval([T{ii,1}{1} '= value;']);
                        else
                            eval([T{ii,1}{1} '= T{ii,1+jj}{1};']);
                        end
                    end
                end
                
                p(jj) = Stimulus; % All param names must be in the form Stimulus.XXX
            end
    end 

end