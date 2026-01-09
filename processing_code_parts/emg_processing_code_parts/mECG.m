classdef mECG < handle
    
    properties
        Buffer={};
        channels = {};
        BufSize={};
        counter={};
        Mode = {};
        Version = {}; %on if device upgraded to contain highpass filter for DC drift
        Fsamp      = {};     %sampling frequency (500 or 250 Hz)
        Res        = {};       %resolution of data, in bytes
        NumCh      = {};       %number of channels read from mECG
        Refresh    = {};    %period of time waited until new data added to plot, in seconds
        NumSamples = {};
        sECG       = {};
    end
    
    methods
        
         function obj=mECG(comport,bdrate,DAQConfig)
%                                            %device name..eg: 'Alpha-122'
%                                            %number of channels
            obj.Buffer=[];
            if ~isempty(DAQConfig)
                obj.channels=DAQConfig.Channels;
                obj.Fsamp      = DAQConfig.SampleRate;     %sampling frequency (500 or 250 Hz)
                obj.Version      = DAQConfig.mECGversion;
            else
                obj.channels=1:8;
                obj.Fsamp      = 2000;     %sampling frequency (500 or 250 Hz)
                obj.Version = 3;
            end
            obj.counter=1;
            obj.Mode=0;
%             obj.Version = 3; %on if device upgraded to contain highpass filter for DC drift
%             obj.Fsamp      = 2000;     %sampling frequency (500 or 250 Hz)
            obj.Res        = 2;       %resolution of data, in bytes
            obj.NumCh      = length(obj.channels);       %number of channels read from mECG
            obj.Refresh    = 0.1;    %period of time waited until new data added to plot, in seconds
            obj.NumSamples = obj.Fsamp*obj.Refresh;
            obj.BufSize    = 2*obj.Fsamp*obj.Res*obj.NumCh;
            try
                b=instrfindall;
                try
                [logic,position]=ismember(comport,b.port);
                if logic
                    delete(b(position));
                end
                end                
                obj.sECG = serial(comport, 'BaudRate', bdrate, 'InputBufferSize', obj.BufSize);     
            catch
                error('the device does not exist');
            end
            
         end
        
         function start(obj)
             
             fopen(obj.sECG);
             CommandByte = bin2dec('10000000');
             
             if obj.Version == 3
                 if obj.Fsamp == 2000
                     CommandByte = CommandByte + bin2dec('00110000');
                 elseif obj.Fsamp == 1000
                     CommandByte = CommandByte + bin2dec('00100000');
                 elseif obj.Fsamp == 500
                     CommandByte = CommandByte + bin2dec('00010000');
                 end
                 
                 if obj.Mode == 3  % test mode
                     CommandByte = CommandByte + bin2dec('00001100');
                 elseif obj.Mode == 2  % 12 leads ECG
                     CommandByte = CommandByte + bin2dec('00001000');
                 elseif obj.Mode == 1  % differential EMG
                     CommandByte = CommandByte + bin2dec('00000100');
                 elseif obj.Mode == 0  % monopolar EMG
                     CommandByte = CommandByte + bin2dec('00000000');
                 end
             elseif obj.Version == 2
                 if obj.Fsamp == 500
                     CommandByte = CommandByte + bin2dec('01000000');
                 end
                 
                 if obj.Mode == 1
                     CommandByte = CommandByte + bin2dec('00100000');
                 end
                 
                 if obj.Res == 2
                     CommandByte = CommandByte + bin2dec('00010000');
                 end
                 
                 if Test == 1
                     CommandByte = CommandByte + bin2dec('00001000');
                 end
                 
                 if Burst == 1
                     CommandByte = CommandByte + bin2dec('00000100');
                 end
             end
             
             CommandByte = CommandByte + (obj.NumCh/2)-1; %set number of channels to be transferred
             fwrite(obj.sECG, CommandByte, 'uint8');
%              pause(0.02)
%              fread(obj.sECG, obj.sECG.BytesAvailable);
             
         end
         
         function stop(obj)
            if ~isempty(obj.sECG)
                 fwrite(obj.sECG, ' ', 'uint8');
                 fclose(obj.sECG);
                
             end
             
         end
        
         function delete(obj)
%             stop(obj);
            delete(obj.sECG);
            clear obj.sECG;
         end
        
         function data=getdata(obj,NbSamples)
 
                data=obj.Buffer(:,1:NbSamples);
                obj.Buffer(:,1:NbSamples)=[];
                %obj.buff(1:NbSamples)= [];
         end

        function clearBuffer(obj)

            %update(obj);
            %flushinput(obj.sECG)
            obj.Buffer=[];
        end
        
        function update(obj)
            pause(0.04)   
            obj.Buffer = fread(obj.sECG, [obj.NumCh, obj.NumSamples], 'int16');
%             data1 = fread(obj.sECG,1600);
%             obj.buff=decode(data1);
%             [obj.result_emg, obj.result_imu, obj.result_emg_idx, obj.result_imu_idx] = ...
%             communicationProtocol(obj.buff, obj.result_emg, obj.result_emg_idx, obj.result_imu, obj.result_imu_idx);
%             obj.Buffer=[obj.Buffer obj.result_emg.'];
        end
           
    end
    
end