## Caparser
## By Daniel Miessler
## Version 1 sucks a lot. Sorry.

# Cleanup
rm hosts.txt
rm hostnames.txt 
rm uniquehosts.txt

# Get the hosts list
tshark -r diphone.pcap -q -z conv,ip 2>/dev/null | cut -d " " -f 1 > hosts.txt 

# Create a seperate pcap for each host
for host in `cat hosts.txt`
do
    tcpdump -r diphone.pcap -w $host.pcap host $host > /dev/null 2>&1
    strings $host.pcap > $host-strings.txt
done

NOC=`wc -l hosts.txt | awk '{print $1}'`

# Get unique hostnames
sort hosts.txt | uniq > uniquehosts.txt 

for host in `cat uniquehosts.txt`
do
    dig -x $host +short >> hostnames.txt 
done
NOH=`wc -l hostnames.txt | awk '{print $1}'`

# Show host list
echo ""
echo "============================"
echo "========== OUTPUT =========="
echo "============================"
echo ""
echo "You made $NOC connections to $NOH hosts."
echo ""
echo "*****************"
echo "*** HOST LIST ***"
echo "*****************"
echo ""
cat hostnames.txt 
echo ""
echo "*****************"

for string in `cat sensitive.txt`
do
    for pcap in `ls *.pcap`
    do
        grep $string $pcap > hit-$pcap.txt
    done
done

for string in `cat sensitive_strings.txt`
do
    echo ""
    echo "There are `tshark -r diphone.pcap | grep -i $string | wc -l | awk '{print $1}'` instances of $string"
    echo ""
    echo "------- SEARCHING FOR $string ----------"
    tshark -r diphone.pcap | grep -i $string
    echo "------- END $string ----------"
    echo ""
done
