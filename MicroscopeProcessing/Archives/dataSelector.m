% find all experiments with FSFG gels
FSFGlist = [];
FSFGinfo = cell(0);
for r=1:runs
    protein = masterInfo{r}.protein;
    if contains(protein,'fsfg','IgnoreCase',true)
        FSFGlist = [FSFGlist r];
        FSFGinfo = [FSFGinfo masterInfo{r}];
    end
end
FSFGlist = FSFGlist';
FSFGinfo = FSFGinfo';
%% find all FSFG 6% experiments
FSFG6list = [];
FSFG6info = cell(0);
for r=1:length(FSFGlist)
    gelNotes = FSFGinfo{r}.gelNotes;
    if contains(gelNotes,'6%','IgnoreCase',true)
        FSFG6list = [FSFG6list r];
        FSFG6info = [FSFG6info FSFGinfo{r}];
    end
end
FSFG6list = FSFG6list';
FSFG6info = FSFG6info';

%% list all useful bis-FSFG 6% ac. gels
data = cell(0);
data = [data FSFG6info{5} FSFG6info{9} FSFG6info{10} FSFG6info{11}]';



