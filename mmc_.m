close;
clear all;

Lamda = 0.5; % ���� �ð��� ��� ���� �մ�
Mu = 1; % ���� �ð��� ���� �޴� ��� �մ��� ��

Num_Customer = 1000000; % �մ��� �� 
num_Server = 3; % ������ ��(C)

Arrival_Time = zeros(Num_Customer,1); % �մ� ���� �ð�
Finish_Time = zeros(Num_Customer,1); % �մ� ���� �ð�
Useable_Server = zeros(num_Server,1); % �����ȿ� ������ �ð�
ServerperNum = zeros(num_Server,1); % �� ���� �̿��ڼ�

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

for i=1:num_Server
    Finish_Time(i) = Arrival_Time(i)+Service_Time(i); % ������ �� ��ŭ �ٷ� ����
    Useable_Server(i) = Finish_Time(i);
    ServerperNum(i) = ServerperNum(i)+1;
end

for i=(num_Server+1):Num_Customer
    num=1;
    for j=2:num_Server % ���� ������ ���� ã��
        if(Useable_Server(num)>Useable_Server(j) )
            num =j;
        end
    end
    Finish_Time(i) = max(Arrival_Time(i)+Service_Time(i),  Useable_Server(num)+Service_Time(i));
    Useable_Server(num) = Finish_Time(i); % ���� ������ ���� �մ� ����
    ServerperNum(num) = ServerperNum(num) + 1; % ���� �̿�� +1
end




Total_Time = Finish_Time - Arrival_Time;  % �� �մ� �� �ð�
Wait_Time  = Total_Time - Service_Time;   % �� �մ� ��ٸ� �ð�

ave_service_time = sum(Service_Time)/Num_Customer % ���� �ð� ���
ave_wait_time = sum(Wait_Time)/Num_Customer % ��ٸ� �ð� ���
ave_total_time = sum(Total_Time)/Num_Customer % �� �ð� ���
ServerperNum % �� ���� �̿��ڼ�

% �ý��ۿ� ��ü �ӹ� �ð� �׷���
subplot(2,1,1)
hist(Total_Time,0:.5:20)
title('Histogram of total times')

% ť���� ���� �� �ð��� ���� ť ���� �׷���
q_length = zeros(ceil(Finish_Time(Num_Customer))+1,1);
for i=1:Num_Customer
  for t=ceil(Arrival_Time(i)):floor(Arrival_Time(i)+Wait_Time(i))  % These are the minutes that cust i was waiting
    q_length(t+1) = q_length(t+1) + 1;
  end
end
subplot(2,1,2)
plot([0:ceil(Finish_Time(Num_Customer))]', q_length)
title('�ð��� ���� Queue ����')
