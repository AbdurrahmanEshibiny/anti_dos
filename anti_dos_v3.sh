#!/bin/bash

sudo apt install -y -qq tcpdump  iptables


declare -A ipTable

function check_history {
	for i in ${!ipTable[*]}
	do
		#echo $i
		if [ "$1" = "$i" ] 
		then
			#echo "IP not new"
			res=$(expr ${ipTable[$i]} + 1)
			unset ipTable[$i]
			ipTable+=([$i]=$res)
			if [ ${ipTable[$i]} -eq 100 ]
			then
				#echo "DDoS attack detected..."
				#ip=`echo $most | awk '{print $2}'`
				sudo iptables -A INPUT -s $i -j DROP
			fi
			return 1
		fi
	done
	#echo "New IP"
	ipTable+=([$1]=1)
}

while read line
do 
	#echo $line
	ip=$( echo $line | awk '{print $2}')
	ip="$(echo $ip | cut -d . -f 1).$(echo $ip | cut -d . -f 2).$(echo $ip | cut -d . -f 3).$(echo $ip | cut -d . -f 4)"
	echo $ip
	check_history $ip
	if [ $SECONDS -gt 1 ]
	then
		unset ipTable
		declare -A ipTable
		sudo iptables -F
		SECONDS=0
		echo "Resetting iptables"
	fi
#	if [ ${ipTable[$line]} -gt 100 ]
#	then
#		continue
#	fi
	# echo "IP: $line , No. of sent requests: ${ipTable[$line]}"
done < <(sudo tcpdump icmp or tcp or udp -tnl)
