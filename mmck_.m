close;
clear all;

Lamda = 0.5; % 단위 시간당 평균 도착 손님
Mu = 1; % 단위 시간당 서비를 받는 평균 손님의 수

Num_Customer = 1000000; % 손님의 수 
Num_Server = 3; % 서버의 수(C)
Num_Queue = 100; % 큐의 길이(K)
block = 0; % block 당한 손님의 수

Arrival_Time = zeros(Num_Customer,1); % 손님 도착 시간
Finish_Time = zeros(Num_Customer,1); % 손님 끝난 시간
Useable_Server = zeros(Num_Server,1); % 서버안에 끝나는 시간
ServerperNum = zeros(Num_Server,1); % 각 서버 이용자수
Queue = zeros(Num_Queue,1); % 큐에 존재하는 인원

% 포아송 분포를 따르는 평균 도착 시간 생성:
UniformRnadom_Number = rand(Num_Customer,1);
% 지수 분포를 따르는 도착 간격 시간 생성
Inter_Arrival_Time =-1/Lamda * log(UniformRnadom_Number); 
Arrival_Time(1) = Inter_Arrival_Time(1);        % 첫번째 손님 도착 시간

for i=2:Num_Customer
    Arrival_Time(i) = Arrival_Time(i-1) + Inter_Arrival_Time(i); % 두번째 손님부터 도착시간
end

UniformRnadom_Numner = rand(Num_Customer,1);
Service_Time = -1/Mu * log(UniformRnadom_Numner);   % 각 손님의 서비스 시간

for i=1:Num_Server
    Finish_Time(i) = Arrival_Time(i)+Service_Time(i); % 서버의 수 만큼 바로 시작
    Useable_Server(i) = Finish_Time(i);
    ServerperNum(i) = ServerperNum(i)+1;
end

for i=(Num_Server+1):Num_Customer
    num=1;
    bnum=block;
    for j=2:Num_Server % 빨리 끝나는 서버 찾기
        if(Useable_Server(num)>Useable_Server(j) )
            num =j;
        end
    end
    
    for m=i:Num_Customer % Queue에 넣기
        check = 0; % Queue에 자리가 있으면 0, 없으면 1
        for k=1:Num_Queue
            if Queue(k)==0
                check=0;
                break;
            else
                check=1;
            end 
        end
        if Arrival_Time(m)>Useable_Server(num)
                break;
        end
        if check ==1
            block = block+1;
            break;
        end
        Queue(k)=Arrival_Time(m);
    end
    
    if bnum>block % block이 발생했다면 밑에 코드 실행 안함
        continue;
    end
    Finish_Time(i) = max(Arrival_Time(i)+Service_Time(i),  Useable_Server(num)+Service_Time(i));
    Useable_Server(num) = Finish_Time(i); % 끝난 서버에 다음 손님 투입
    ServerperNum(num) = ServerperNum(num) + 1; % 서버 이용고객 +1
    
    for j=1:(Num_Queue-1) % Queue 앞으로 한칸씩 당기기
        Queue(j)=Queue(j+1);
        if j==(Num_Queue-1)
            Queue(Num_Queue)=0;
        end
    end
end




Total_Time = Finish_Time - Arrival_Time;  % 각 손님 총 시간
Wait_Time  = Total_Time - Service_Time;   % 각 손님 기다린 시간

ave_service_time = sum(Service_Time)/Num_Customer % 서비스 시간 평균
ave_wait_time = sum(Wait_Time)/Num_Customer % 기다린 시간 평균
ave_total_time = sum(Total_Time)/Num_Customer % 총 시간 평균
blockingRate = block/Num_Customer % block당한 비율
ServerperNum % 각 서버 이용자수



