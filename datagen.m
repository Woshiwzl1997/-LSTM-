clc
clear all
N_t=64;%��������
fre_N=200;%Ƶ�ʼ�����
freset=10e5:(10e5/fre_N):20e5;%Ƶ�ʼ�
fs=40e5;%����Ƶ��

fm=1e3;%����Ƶ��
train_num=10000;
%% ����ѵ�����ݼ�
train_lab=[];
train_sig=[];
tao=10;
show=1;
for n=1:train_num
    %������������
    split_posi=randi([2,N_t-2],1);%��Ƶ��
    tl=(0:split_posi-1)*(1/fs);%l��
    tr=(split_posi:N_t-1)*(1/fs);%r��

    f=randperm(fre_N, 2);%�����Ƶ�ʼ���ѡ������Ƶ��
    
    cur_label=max(0,1-abs(split_posi-N_t/2)/tao);
    train_lab=[train_lab;cur_label];
    signall=exp(1i*2*pi*(freset(f(1))+randi([1,4],1)*fm)*tl);%�����ź�
    signalr=exp(1i*2*pi*(freset(f(2))+randi([1,4],1)*fm)*tr);
    cur_signal=[signall signalr];
    spec=abs(fft(cur_signal,N_t));
    spec=mapminmax(spec,0,1);
    train_sig=[train_sig;spec];

    %%��ͼ
    if show==1
       freset(f(1))
       freset(f(2))
       ff=(0:N_t-1)*(fs/N_t);
       figure()
       plot(ff,spec);
       show=0;
    end
end
%���쵥Ƶ����
for n=1:train_num/10
    t=(0:N_t-1)*(1/fs);
    ff=randperm(fre_N, 1);
    train_lab=[train_lab;0];
    signal=exp(1i*2*pi*(freset(ff)+randi([1,4],1)*fm)*t);
    spec=abs(fft(signal,N_t));
    spec=mapminmax(spec,0,1);%��һ��
    train_sig=[train_sig;spec];
end
save('traindata.mat','train_sig','train_lab')
%% �����������
test_fre=[12e5,18e5,13e5,20e5];
test_lab=[];
test_sig=[];
for n=1:length(test_fre)-1
    %��Ƶ
    test_lab=[test_lab;0];
    signal=exp(1i*2*pi*(test_fre(n)+randi([1,4],1)*fm)*t);
    spec=abs(fft(signal,N_t));
    spec=mapminmax(spec,0,1);
    test_sig=[test_sig;spec];
    %��Ƶ
    for hop=2:N_t-2
        split_posi=hop;%��Ƶ��
        tl=(0:split_posi-1)*(1/fs);
        tr=(split_posi:N_t-1)*(1/fs);
        
        cur_label=max(0,1-abs(split_posi-N_t/2)/tao);
        test_lab=[test_lab;cur_label];
        
        signall=exp(1i*2*pi*(test_fre(n)+randi([1,4],1)*fm)*tl);%�����ź�
        signalr=exp(1i*2*pi*(test_fre(n+1)+randi([1,4],1)*fm)*tr);
        
        cur_signal=[signall signalr];
        spec=abs(fft(cur_signal,N_t));
        spec=mapminmax(spec,0,1);
        
        test_sig=[test_sig;spec];
        if hop==N_t/2
           ff=(0:N_t-1)*(fs/N_t);
           figure()
           plot(ff,spec);
        end
    end
end
save('testdata.mat','test_sig','test_lab')




