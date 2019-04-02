#!/bin/bash
#UP
group="test100k10"
cd /home/amax/Documents/shell/HmMdata/Android
sudo mkdir ${group}"up"
sudo mkdir ${group}"down"
cd ..
cd Server
sudo mkdir ${group}"up"
sudo mkdir ${group}"down"

echo "Uplink test start"
for i in {1..30}
do
sudo tcpdump -i enp96s0f0 -w /home/amax/Documents/shell/HmMdata/Server/${group}"up"/"test"${i}.pcap&
echo "The server starts to capture uplink packets"${i}
adb shell /data/local/tcpdump -i wlan0 -p -vv -s0 -w /sdcard/tcpdumpdata/Mdata/up/"test"${i}.pcap&
echo "The Android starts to capture uplink packets"${i}
#Screen operation
adb shell input tap 190 160   
adb shell input tap 424 538           
adb shell input tap 525 1958
echo "The test is running"         
sleep 20 

adb shell killall tcpdump  
sudo killall tcpdump               
echo "The Android stop capturing uplink packets"${i}        
echo "The server stop capturing uplink packets"${i} 

adb pull /sdcard/tcpdumpdata/Mdata/up/"test"${i}.pcap /home/amax/Documents/shell/HmMdata/Android/${group}"up"&
echo "Pull the uplink file in android side to server ${i}"
done
echo "uplink test finished"


#DOWN
echo "Downlink test start"
for i in {1..30}
do
sudo tcpdump -i enp96s0f0 -w /home/amax/Documents/shell/HmMdata/Server/${group}"down"/"test"${i}.pcap&
echo "The server starts to capture downlink packets"${i}
adb shell /data/local/tcpdump -i wlan0 -p -vv -s0 -w /sdcard/tcpdumpdata/Mdata/down/"test"${i}.pcap&
echo "The Android starts to capture downlink packets"${i}
#Screen operation
adb shell input tap 190 160            
adb shell input tap 588 541       
adb shell input tap 525 1958
echo "The test is running"          
sleep 23                  
adb shell killall tcpdump     
sudo killall tcpdump            
echo "The Android stop capturing downlink packets"${i}
echo "The server stop capturing downlink packets"${i}

adb pull /sdcard/tcpdumpdata/Mdata/down/"test"${i}.pcap /home/amax/Documents/shell/HmMdata/Android/${group}"down"&
echo "Pull the downlink file in android side to server ${i}"
done
echo "downlink test finished"





#Data extract
S_up_filepath="/home/amax/Documents/shell/HmMdata/Server/"${group}"up/"
A_up_filepath="/home/amax/Documents/shell/HmMdata/Android/"${group}"up/"
S_down_filepath="/home/amax/Documents/shell/HmMdata/Server/"${group}"down/"
A_down_filepath="/home/amax/Documents/shell/HmMdata/Android/"${group}"down/"
cd /home/amax/Documents/shell/HmMdata/FilterData/Server
sudo mkdir ${group}"up"
sudo mkdir ${group}"down"
cd ..
cd Android
sudo mkdir ${group}"up"
sudo mkdir ${group}"down"
S_up_filter_datapath="/home/amax/Documents/shell/HmMdata/FilterData/Server/"${group}"up/"
A_up_filter_datapath="/home/amax/Documents/shell/HmMdata/FilterData/Android/"${group}"up/"
S_down_filter_datapath="/home/amax/Documents/shell/HmMdata/FilterData/Server/"${group}"down/"
A_down_filter_datapath="/home/amax/Documents/shell/HmMdata/FilterData/Android/"${group}"down/"

S_up_datapath="/home/amax/Documents/shell/HmMdata/Testdata/Server/"
A_up_datapath="/home/amax/Documents/shell/HmMdata/Testdata/Android/"
S_down_datapath="/home/amax/Documents/shell/HmMdata/Testdata/Server/"
A_down_datapath="/home/amax/Documents/shell/HmMdata/Testdata/Android/"

#Datapath="/home/amax/Documents/shell/HmMdata/Testdata/"
cd /home/amax/Documents/shell/HmMdata/Testdata/Server
sudo mkdir ${group}
cd ${group}
sudo mkdir ${group}"up"
sudo mkdir ${group}"down"
cd ${group}"up"
sudo touch data.csv
sudo chmod 777 data.csv
cd ..
cd ${group}"down"
sudo touch data.csv
sudo chmod 777 data.csv


cd ..
cd ..
cd ..
cd Android
sudo mkdir ${group}
cd ${group}
sudo mkdir ${group}"up"
sudo mkdir ${group}"down"
cd ${group}"up"
sudo touch data.csv
sudo chmod 777 data.csv
cd ..
cd ${group}"down"
sudo touch data.csv
sudo chmod 777 data.csv


cd $S_up_filepath
for i in {1..30}
do 
  sudo tshark -r "test"${i}.pcap -Y '(ip.dst==192.168.1.11 and tcp.port==6002)' -w ${S_up_filter_datapath}"testdata"${i}.pcap
  sudo tshark -r ${S_up_filter_datapath}"testdata"${i}.pcap -q -z conv,tcp>>${S_up_datapath}${group}"/${group}up/data".csv
done     
echo "Server uplink data extract finish"



cd $A_up_filepath
for i in {1..30}
do 
  sudo tshark -r "test"${i}.pcap -Y '(ip.dst==192.168.1.11 and tcp.port==6002)' -w ${A_up_filter_datapath}"testdata"${i}.pcap
  sudo tshark -r ${A_up_filter_datapath}"testdata"${i}.pcap -q -z conv,tcp>>${A_up_datapath}${group}"/${group}up/data".csv
done     
echo "Android uplink data extract finish"



cd $S_down_filepath
for i in {1..30}
do 
  sudo tshark -r "test"${i}.pcap -Y '(ip.src==192.168.1.11 and tcp.port==6001)' -w ${S_down_filter_datapath}"testdata"${i}.pcap
  sudo tshark -r ${S_down_filter_datapath}"testdata"${i}.pcap -q -z conv,tcp>>${S_down_datapath}${group}"/${group}down/data".csv
done     
echo "Server downlink data extract finish"



cd $A_down_filepath
for i in {1..30}
do 
  sudo tshark -r "test"${i}.pcap -Y '(ip.src==192.168.1.11 and tcp.port==6001)' -w ${A_down_filter_datapath}"testdata"${i}.pcap
  sudo tshark -r ${A_down_filter_datapath}"testdata"${i}.pcap -q -z conv,tcp>>${A_down_datapath}${group}"/${group}down/data".csv
done     
echo "Android downlink data extract finish"

#Delete file in android side
adb shell rm /sdcard/tcpdumpdata/Mdata/up/test* 
adb shell rm /sdcard/tcpdumpdata/Mdata/down/test*
echo "Delete finish"

echo "The group ${group} test finish"






