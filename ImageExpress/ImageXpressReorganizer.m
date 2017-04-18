clear; clc
curdir=pwd;

w=waitbar(0,'Deleting Thumbs');

direct=dir;
OriginalFolderCount=numel(direct)-2;
%this removes the thumbs for you
for f=1:OriginalFolderCount
    cd(direct(f+2).name);
    direct(f+2).name
    delete('*thumb*');
    cd(curdir)
end

cd(direct(3).name)
subdirect=dir; 
for i=1:numel(subdirect(3).name)
    if subdirect(3).name(i)=='_' 
        m=i-1;
        break 
    end
end
ExperimentName=subdirect(3).name(1:m);
cd(curdir)

if subdirect(3).name(m+5)~='_'
    %type 1 = one site one wavelength
    nametype=1;
    
elseif subdirect(3).name(m+6)=='s'
    if subdirect(3).name(m+9)~='w'&&subdirect(3).name(m+10)~='w'
    %type 2 = multiple sites one wavelength
        nametype=2;
    else
    %type 4 = multiple sites multiple wavelengths
    nametype=4;
    end
elseif subdirect(3).name(m+6)=='w'
    %type 3 = one site multiple wavelengths
    nametype=3;
end

if numel(dir('TimePoint_0'))>0;
    firstpoint=0;
else
    firstpoint=1;
end

timepoints=OriginalFolderCount-1+firstpoint;

if nametype==1
    for t=firstpoint:timepoints
        if t==firstpoint, tic, w=waitbar(0,w,'Calculating Time Remaining');end
        M = 1;
        xmax = double(max(abs(t(:))));
        if xmax>=1
            M = M + floor(log10(xmax));               
            if M<2, M = 2; end
        else
            M = M+1;
        end
        S = sprintf(['%0' int2str(M) '.0f'],round(t(:)));
        S = reshape(S,M,numel(t)).';
        Timepoint=S;
        
        timefolder=['TimePoint_',int2str(t)];
        
        cd(timefolder)
        for y=1:16 %A to P
            Row=char(y+64);
            rowname=[ExperimentName,'_',Row,'*'];
            if numel(dir(rowname))>0
                for x=1:24
                    M = 1;
                    xmax = double(max(abs(x(:))));
                    if xmax>=1
                        M = M + floor(log10(xmax));               
                        if M<2, M = 2; end
                    else
                        M = M+1;
                    end
                    S = sprintf(['%0' int2str(M) '.0f'],round(x(:)));
                    S = reshape(S,M,numel(x)).';
                    Column=S;
                
                        file=[ExperimentName,'_',Row,Column,'*'];
                        if numel(dir(file))>0
                            if t>firstpoint
                                w=waitbar(t/timepoints,w,['estimated time remaining: ',int2str(t1*timepoints*(1-(t/timepoints))/60),' minutes']);
                            end
                            imageD=dir(file);
                            image=imread(imageD(1).name);
                            if t<firstpoint+1
                                cd(curdir)
                                foldername=['well ',Row, Column];
                                mkdir(foldername);
                            end
                            imagename=['t',Timepoint];
                            foldername=['well ', Row ,Column];
                            cd(curdir);
                            NewDirect=dir;
                            cd (foldername)
                            imwrite(image,[imagename,'.tif'])
                            cd(curdir)
                            cd(timefolder)
                        end
                      
                end
            end
        end
        if t==firstpoint,t1=toc;end
        cd(curdir)
    end

elseif nametype==2
    for t=firstpoint:timepoints
        if t==firstpoint, tic, w=waitbar(0,w,'Calculating Time Remaining');end
        M = 1;
        xmax = double(max(abs(t(:))));
        if xmax>=1
            M = M + floor(log10(xmax));               
            if M<2, M = 2; end
        else
            M = M+1;
        end
        S = sprintf(['%0' int2str(M) '.0f'],round(t(:)));
        S = reshape(S,M,numel(t)).';
        Timepoint=S;
        
        timefolder=['TimePoint_',int2str(t)];
        
        cd(timefolder)
        for y=1:16 %A to P
            Row=char(y+64);
            rowname=[ExperimentName,'_',Row,'*'];
            if numel(dir(rowname))>0
                for x=1:24
                    M = 1;
                    xmax = double(max(abs(x(:))));
                    if xmax>=1
                        M = M + floor(log10(xmax));               
                        if M<2, M = 2; end
                    else
                        M = M+1;
                    end
                    S = sprintf(['%0' int2str(M) '.0f'],round(x(:)));
                    S = reshape(S,M,numel(x)).';
                    Column=S;
                
                        file=[ExperimentName,'_',Row,Column,'_s*'];
                        if numel(dir(file))>0
                            if t>firstpoint
                                w=waitbar(t/timepoints,w,['estimated time remaining: ',int2str(t1*timepoints*(1-(t/timepoints))/60),' minutes']);
                            end
                            NumberofSites=numel(dir(file));
                            for s=1:NumberofSites
                                cd(curdir),cd(timefolder)
                                file=[ExperimentName,'_',Row,Column,'_s',int2str(s),'*'];
                                imageD=dir(file);
                                image=imread(imageD(1).name);
                                if t<firstpoint+1
                                    if s<2
                                        cd(curdir)
                                        foldername=['well ',Row, Column];
                                        mkdir(foldername);
                                    end
                                end
                                imagename=['site ', int2str(s),' t',Timepoint];
                                foldername=['well ', Row ,Column];
                                cd(curdir);
                                NewDirect=dir;
                                cd (foldername)
                                imwrite(image,[imagename,'.tif'])
                                cd(curdir)
                                cd(timefolder)
                            end
                        end
                end
            end
        end
        if t==firstpoint,t1=toc;end
        cd(curdir)
    end
elseif nametype==3
    for t=firstpoint:timepoints
        if t==firstpoint, tic, w=waitbar(0,w,'Calculating Time Remaining');end
        M = 1;
        xmax = double(max(abs(t(:))));
        if xmax>=1
            M = M + floor(log10(xmax));               
            if M<2, M = 2; end
        else
            M = M+1;
        end
        S = sprintf(['%0' int2str(M) '.0f'],round(t(:)));
        S = reshape(S,M,numel(t)).';
        Timepoint=S;
        
        timefolder=['TimePoint_',int2str(t)];
        
        cd(timefolder)
        for y=1:16 %A to P
            Row=char(y+64);
            rowname=[ExperimentName,'_',Row,'*'];
            if numel(dir(rowname))>0
                for x=1:24
                    M = 1;
                    xmax = double(max(abs(x(:))));
                    if xmax>=1
                        M = M + floor(log10(xmax));               
                        if M<2, M = 2; end
                    else
                        M = M+1;
                    end
                    S = sprintf(['%0' int2str(M) '.0f'],round(x(:)));
                    S = reshape(S,M,numel(x)).';
                    Column=S;
                
                        file=[ExperimentName,'_',Row,Column,'*'];
                        if numel(dir(file))>0
                            if t>firstpoint
                                w=waitbar(t/timepoints,w,['estimated time remaining: ',int2str(t1*timepoints*(1-(t/timepoints))/60),' minutes']);
                            end
                        
                            file=[ExperimentName,'_',Row,Column,'_w*'];
                            imageD=dir(file);
                            NumberofWavelengths=numel(imageD);                    
                            images=zeros((length(imread(imageD(1).name))),length((imread(imageD(1).name))),NumberofWavelengths);
                            for i=1:NumberofWavelengths
                                images=uint16(images);
                                images(:,:,i)=imread(imageD(i).name);
                            end
                            if t<firstpoint+1
                                cd(curdir)
                                foldername=['well ',Row, Column];
                                mkdir(foldername);
                            end
                            for i=1:NumberofWavelengths
                                imagename=['wavelength ',int2str(i),' t',Timepoint];
                                foldername=['well ', Row ,Column];
                                image=images(:,:,i);
                                cd(curdir);
                                NewDirect=dir;
                                cd (foldername)
                                imwrite(image,[imagename,'.tif'])
                            end
                            cd(curdir)
                            cd(timefolder)
                        end
                end
            end
        end
        if t==firstpoint,t1=toc;end
        cd(curdir)
    end
elseif nametype==4
	for t=firstpoint:timepoints
        if t==firstpoint, tic, w=waitbar(0,w,'Calculating Time Remaining');end
        M = 1;
        xmax = double(max(abs(t(:))));
        if xmax>=1
            M = M + floor(log10(xmax));               
            if M<2, M = 2; end
        else
            M = M+1;
        end
        S = sprintf(['%0' int2str(M) '.0f'],round(t(:)));
        S = reshape(S,M,numel(t)).';
        Timepoint=S;
        
        timefolder=['TimePoint_',int2str(t)];
        
        cd(timefolder)
        for y=1:16 %A to P
            Row=char(y+64);
            rowname=[ExperimentName,'_',Row,'*'];
            if numel(dir(rowname))>0
                for x=1:24
                    M = 1;
                    xmax = double(max(abs(x(:))));
                    if xmax>=1
                        M = M + floor(log10(xmax));               
                        if M<2, M = 2; end
                    else
                        M = M+1;
                    end
                    S = sprintf(['%0' int2str(M) '.0f'],round(x(:)));
                    S = reshape(S,M,numel(x)).';
                    Column=S;
                    file=[ExperimentName,'_',Row,Column,'_s*_w1*'];
                    if numel(dir(file))>0
                        if t>firstpoint
                        	w=waitbar(t/timepoints,w,['estimated time remaining: ',int2str(t1*timepoints*(1-(t/timepoints))/60),' minutes']);
                        end
                        NumberofSites=numel(dir(file));
                        for s=1:NumberofSites
                        	file=[ExperimentName,'_',Row,Column,'_s',int2str(s),'_w*'];
                            imageD=dir(file);
                            NumberofWavelengths=numel(imageD);                    
                            images=zeros((length(imread(imageD(1).name))),length((imread(imageD(1).name))),NumberofWavelengths);
                            for i=1:NumberofWavelengths
                            	images=uint16(images);
                            	images(:,:,i)=imread(imageD(i).name);
                            end
                            if t<firstpoint+1
                            	if s<2
                                	cd(curdir)
                                	foldername=['well ',Row, Column];
                                	mkdir(foldername);
                            	end
                            end
                            for i=1:NumberofWavelengths
                            	imagename=['site ', int2str(s), ' wavelength ',int2str(i),' t',Timepoint];
                                foldername=['well ', Row ,Column];
                                image=images(:,:,i);
                                cd(curdir);
                                NewDirect=dir;
                                cd (foldername)
                                imwrite(image,[imagename,'.tif'])
                            end
                            cd(curdir)
                            cd(timefolder)
                         end
                      
                     end
                end
            end
        end
        cd(curdir)
        if t==firstpoint,t1=toc;end
	end
end

try
    rmdir('*TimePoint*','s')
catch
    try
        rmdir('*TimePoint*','s')
    catch
        warning('Thumb.db could not be deleted at this time')
    end
end
close(w)
