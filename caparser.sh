## Caparser: Find plaintext sensitive data in ur netwerk traffics.
## By Daniel Miessler
## Version 1 sucks a lot. Sorry.

# Cleanup
rm hosts.txt
rm hostnames.txt 
rm uniquehosts.txt
rm pcap_strings.txt
rm totalhits.txt
#rm malwarecheck.txt

# Get the hosts list
tshark -r diphone.pcap -q -z conv,ip | awk '{print $3}' | grep "^[0-9]" | sort | uniq | awk '{print $1}' >> hosts.txt

# Create a seperate pcap for each host
for host in `cat hosts.txt`
do
    tcpdump -r diphone.pcap -w $host.pcap host $host > /dev/null 2>&1
    #strings $host.pcap > $host-strings.txt
done

NOC=`wc -l hosts.txt | awk '{print $1}'`

# Get unique hostnames
sort hosts.txt | uniq > uniquehosts.txt 

#for host in `cat uniquehosts.txt`
#do
#    /Users/daniel/Development/vtscan/vtcheck -u $host >> malwarecheck.txt 
#done

for host in `cat uniquehosts.txt`
do
    dig -x $host +short >> hostnames.txt 
done
NOH=`wc -l hostnames.txt | awk '{print $1}'`


# Get strings from the SecLists project
curl -O https://raw.githubusercontent.com/danielmiessler/SecLists/master/Pattern_Matching/pcap_strings.txt

# Output based on hits
for string in `cat pcap_strings.txt`
do
    echo ""
    echo "There are `tshark -r diphone.pcap | grep -i $string | wc -l | awk '{print $1}'` instances of $string"
    tshark -r diphone.pcap | grep -i $string | wc -l | awk '{print $1}' >> totalhits.txt
    echo ""
    echo "------- SEARCHING FOR $string ----------"
    tshark -r diphone.pcap | grep -i $string
    echo "------- END $string ----------"
    echo ""
done

# Output

echo "Scanning pcap…"
sleep 3

echo ""
echo "============================"
echo "========== OUTPUT =========="
echo "============================"

echo ""
echo "You made $NOC connections to $NOH hosts."
echo ""

sleep 2

echo ""
echo "*** HOST LIST ***"
echo ""
sleep 1
echo "Printing hostnames…"
sleep 1
cat hostnames.txt 
echo ""

sleep 2
echo "Printing hits…"
sleep 1

echo "Total instances of sensitive string hits:"
echo ""
cat totalhits.txt
