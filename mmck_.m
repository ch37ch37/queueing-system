close;
clear all;

Lamda = 0.5; % ���� �ð��� ��� ���� �մ�
Mu = 1; % ���� �ð��� ���� �޴� ��� �մ��� ��

Num_Customer = 1000000; % �մ��� �� 
Num_Server = 3; % ������ ��(C)
Num_Queue = 100; % ť�� ����(K)
block = 0; % block ���� �մ��� ��

Arrival_Time = zeros(Num_Customer,1); % �մ� ���� �ð�
Finish_Time = zeros(Num_Customer,1); % �մ� ���� �ð�
Useable_Server = zeros(Num_Server,1); % �����ȿ� ������ �ð�
ServerperNum = zeros(Num_Server,1); % �� ���� �̿��ڼ�
Queue = zeros(Num_Queue,1); % ť�� �����ϴ� �ο�

% ���Ƽ� ������ ������ ��� ���� �ð� ����:
UniformRnadom_Number = rand(Num_Customer,1);
% ���� ������ ������ ���� ���� �ð� ����
Inter_Arrival_Time =-1/Lamda * log(UniformRnadom_Number); 
Arrival_Time(1) = Inter_Arrival_Time(1);        % ù��° �մ� ���� �ð�

for i=2:Num_Customer
    Arrival_Time(i) = Arrival_Time(i-1) + Inter_Arrival_Time(i); % �ι�° �մԺ��� �����ð�
end

UniformRnadom_Numner = rand(Num_Customer,1);
Service_Time = -1/Mu * log(UniformRnadom_Numner);   % �� �մ��� ���� �ð�

for i=1:Num_Server
    Finish_Time(i) = Arrival_Time(i)+Service_Time(i); % ������ �� ��ŭ �ٷ� ����
    Useable_Server(i) = Finish_Time(i);
    ServerperNum(i) = ServerperNum(i)+1;
end

for i=(Num_Server+1):Num_Customer
    num=1;
    bnum=block;
    for j=2:Num_Server % ���� ������ ���� ã��
        if(Useable_Server(num)>Useable_Server(j) )
            num =j;
        end
    end
    
    for m=i:Num_Customer % Queue�� �ֱ�
        check = 0; % Queue�� �ڸ��� ������ 0, ������ 1
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
    
    if bnum>block % block�� �߻��ߴٸ� �ؿ� �ڵ� ���� ����
        continue;
    end
    Finish_Time(i) = max(Arrival_Time(i)+Service_Time(i),  Useable_Server(num)+Service_Time(i));
    Useable_Server(num) = Finish_Time(i); % ���� ������ ���� �մ� ����
    ServerperNum(num) = ServerperNum(num) + 1; % ���� �̿�� +1
    
    for j=1:(Num_Queue-1) % Queue ������ ��ĭ�� ����
        Queue(j)=Queue(j+1);
        if j==(Num_Queue-1)
            Queue(Num_Queue)=0;
        end
    end
end




Total_Time = Finish_Time - Arrival_Time;  % �� �մ� �� �ð�
Wait_Time  = Total_Time - Service_Time;   % �� �մ� ��ٸ� �ð�

ave_service_time = sum(Service_Time)/Num_Customer % ���� �ð� ���
ave_wait_time = sum(Wait_Time)/Num_Customer % ��ٸ� �ð� ���
ave_total_time = sum(Total_Time)/Num_Customer % �� �ð� ���
blockingRate = block/Num_Customer % block���� ����
ServerperNum % �� ���� �̿��ڼ�



