function info = set_input(volcName,inputFile)
    disp(['Input from: ',inputFile]);

    info = struct;
    info.name = volcName;
    
    endc = strfind(inputFile,'.')-1;    
    tmp = datestr(datetime('now'),'YYYYMMDD_hhmm_');
    folderOut = 'OutputFiles';
    info.name_files = [folderOut filesep tmp strtrim(inputFile(1:endc(1)))];
    if not(exist(folderOut))
        mkdir(folderOut)
    end
    
    fid = fopen(inputFile);

    tline = fgetl(fid);    
    endc = strfind(tline,'%')-1;    
    tmp = str2num(tline(1:endc(1)));
    info.total_last = tmp;    
    
    tline = fgetl(fid);    
    endc = strfind(tline,'%')-1;    
    tmp = str2num(tline(1:endc(1)));
    info.total_per = tmp;
    
    tline = fgetl(fid);    
    endc = strfind(tline,'%')-1;    
    tmp = str2num(tline(1:endc(1)));
    info.background_ev = tmp;
    
    for icl = 1 : info.background_ev      
        tline = fgetl(fid);    
        endc = strfind(tline,'%')-1;    
        tmp = str2num(tline(1:endc(1)));
        info.cluster(icl).yy_s = tmp;
        
        tline = fgetl(fid);    
        endc = strfind(tline,'%')-1;    
        tmp = str2num(tline(1:endc(1)));
        info.cluster(icl).len = tmp;        
        
        tline = fgetl(fid);    
        endc = strfind(tline,'%')-1;    
        tmp = strtrim(tline(1:endc(1)));
        if strcmpi(tmp,'Y')         
            info.cluster(icl).use4lambdaYN = true;        
        elseif strcmpi(tmp,'N')         
            info.cluster(icl).use4lambdaYN = false;
        else
            disp('!!! Error in input file')
            stop
        end
        
        tline = fgetl(fid);    
        %if info.cluster(icl).use4lambdaYN
            endc = strfind(tline,'%')-1;    
            tmp = str2num(tline(1:endc(1)));
            info.cluster(icl).nev = tmp;        
        %else
        %    info.cluster(icl).nev = nan;
        %end
        
    end    
    fclose(fid);    
    
    %% FURTHER PARAMETERS
    for i=1:length(info.cluster)-1
       info.repose_times(i) = info.cluster(i+1).yy_s - info.cluster(i).yy_s -info.cluster(i).len;
    end    
    info.censoring = info.total_last - info.cluster(end).yy_s - info.cluster(end).len;    
    
    info
    
    save([info.name_files '_info.mat'],'info')

end
