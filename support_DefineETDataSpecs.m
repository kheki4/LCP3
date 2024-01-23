function Config = support_DefineETDataSpecs(Config)

    Config.ETDeviceDirName = '*';
    Config.ETDataFileNameEnding = '*';
    if(strcmp(Config.ETDataFormat, 'SMI'))
        Config.ETDeviceDirName = 'ET_SMI_TXT';
        Config.ETDataFileNameEnding = ' Samples.txt'; % the whitespace is needed
    elseif(strcmp(Config.ETDataFormat, 'PupilEXT'))
        Config.ETDeviceDirName = 'ET_PUPILEXT_CSV';
        Config.ETDataFileNameEnding = '.csv';

        log_w('PupilEXT only supports PX data yet')
        Config.PXorMM = true;
    elseif(strcmp(Config.ETDataFormat, 'EyeLink'))
        Config.ETDeviceDirName = 'ET_EYELINK_ASC';
        Config.ETDataFileNameEnding = '.asc';
    elseif(strcmp(Config.ETDataFormat, 'Other'))
        Config.ETDeviceDirName = 'ET_OTHER_XLSX';
        Config.ETDataFileNameEnding = '.xlsx';
    end

end