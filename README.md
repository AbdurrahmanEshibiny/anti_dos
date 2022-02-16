# anti_dos
Simple bash script to counter ICMP echo request, TCP/SYN, and UDP DoS attacks.
This script uses `tcpdump` and `iptables` to detect and block attacking requests that exceed 100 requests/second

Note: If your system doesn't have `tcpdump` and `iptables` installed, the script will automatically install them for you via the `apt` package manager.
