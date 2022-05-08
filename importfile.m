low = [697 770 852 941];    
high = [1209 1336 1477];
tele = [1,2,3; 4,5,6; 7,8,9; 11,0,12];    % '*' = 11; '#' = 12
[yy,fs]=audioread('sdtmf(-5dB).wav');%������Ƶ�ļ�
audio1=audioinfo('sdtmf(-5dB).wav');
t=0:seconds(1/fs):seconds(audio1.Duration);
t=t(1:end-1);
grid on; %������
hold on; %����ͼ�񱣳�
YY=fft(yy);%���������и���Ҷ�任
f=(0:audio1.TotalSamples-1)*fs/audio1.TotalSamples;
subplot(2,1,1); 
figure(1);
plot(abs(yy),'b');%����ʱ����
title('����ʱ����');
figure(2);
subplot(2,1,2); 
plot(abs(YY),'b');%����Ƶ����
title('����Ƶ����');

%����һ����ͨ�˲�����������˹�˲�����
wp =690 / (fs/2);  %ͨ����ֹƵ��,�������һ��
ws = 950 / (fs/2);  %�����ֹƵ��,�������һ��
alpha_p = 3;               %ͨ���������˥��Ϊ 3 db
alpha_s = 10;              %���������С˥��Ϊ 10 db
%���ת�ƺ���ϵ��
[ b, a ] = butter(2, [wp ws], 'bandpass');
%�˲�
s1 = filter(b,a,yy);
w1 = fft(s1);
figure(3);
plot(t,s1);
figure(4);
plot(f,w1);
N=seconds(0.05)/seconds(audio1.Duration)*audio1.TotalSamples;
%��֡
a=zeros(1,audio1.TotalSamples);
for i=1:audio1.TotalSamples
    for j=i:i+N
        if j~=1&&j<audio1.TotalSamples
            a(i)=a(i)+s1(j)^2;
        end
    end
end
figure(5);
plot(1:audio1.TotalSamples,a);
title('��ʱ����');
[p,location2] = findpeaks(a,'minpeakheight',25);
location2=[21134,23032,24546,25561,27099,28976,30163,31757,33545];
freq_indices = round(low/fs*N) + 1;  
for i=1:length(location2)
    figure(5+i);
    v=goertzel(s1(location2(i):location2(i)+N-1),freq_indices);
    [M,index1]=max(abs(v));
    low_f(i)=low(index1);
    stem(low,abs(v));
end

%������ͨ�˲�����ͬ��ʹ�ð�����˹�˲�����
wp2 =1200/ (fs/2);  %ͨ����ֹƵ��,�������һ��
ws2 = 1500 / (fs/2);  %�����ֹƵ��,�������һ��
alpha_p = 3;               %ͨ���������˥��Ϊ 3 db
alpha_s = 10;              %���������С˥��Ϊ 10 db
%���ת�ƺ���ϵ��
[ b2, a2 ] = butter(2, [wp2 ws2], 'bandpass');
%�˲�
s2 = filter(b2,a2,yy);
w2 = fft(s2);
figure(15);
plot(t,s2);
figure(16);
plot(f,w2);
N=seconds(0.05)/seconds(audio1.Duration)*audio1.TotalSamples;
%��֡
a2=zeros(1,audio1.TotalSamples);
for i=1:audio1.TotalSamples
    for j=i:i+N
        if j~=1&&j<audio1.TotalSamples
            a2(i)=a2(i)+s2(j)^2;
        end
    end
end
figure(17);
plot(1:audio1.TotalSamples,a2);
title('��ʱ����');
[p2,location2] = findpeaks(a2,'minpeakheight',25);
location2=[21134,23032,24546,25561,27099,28976,30163,31757,33545];
freq_indices = round(high/fs*N) + 1;  
for i=1:length(location2)
    figure(20+i);
    v2=goertzel(s1(location2(i):location2(i)+N-1),freq_indices);
    [M,index2]=max(abs(v2));
    high_f(i)=low(index2);
    stem(high,abs(v2));
end