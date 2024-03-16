#!/bin/bash
#colors
Blue="\e[34m";
end="\e[0m";

#banner

echo -e "${Blue}

██╗  ██╗███████╗███████╗██╗  ██╗██╗   ██╗███╗   ██╗████████╗
╚██╗██╔╝██╔════╝██╔════╝██║  ██║██║   ██║████╗  ██║╚══██╔══╝
 ╚███╔╝ ███████╗███████╗███████║██║   ██║██╔██╗ ██║   ██║   
 ██╔██╗ ╚════██║╚════██║██╔══██║██║   ██║██║╚██╗██║   ██║   
██╔╝ ██╗███████║███████║██║  ██║╚██████╔╝██║ ╚████║   ██║   
╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   
                                                            
                                                   ${end} by @ESLAM2012"
# Check if the domain argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

# Set variables
domain="$1"
output_dir="xss_scan_results"
wayback_urls_file="$output_dir/wayback_urls.txt"
kxss_results_file="$output_dir/kxss_results.txt"
ksstrike_results_file="$output_dir/ksstrike_results.txt"
gxss_results_file="$output_dir/gxss_results.txt"

# Create output directory
mkdir -p "$output_dir"

# Function to run a command and check for errors
run_command() {
    command="$1"
    echo "[*] Running: $command"
    eval "$command"
    if [ $? -ne 0 ]; then
        echo "[!] Error occurred while running: $command"
        exit 1
    fi
    echo "[+] Command completed successfully"
}

# Collect URLs from Wayback Machine
run_command "waybackurls $domain | sort -u > $wayback_urls_file"
echo "[+] URLs collected and saved to $wayback_urls_file"

# Run Kxss on collected URLs
run_command "cat $wayback_urls_file | kxss > $kxss_results_file"
echo "[+] Kxss scan completed. Results saved to $kxss_results_file"

# Run Ksstrike on collected URLs
run_command "ksstrike -d $domain -o $ksstrike_results_file"
echo "[+] Ksstrike scan completed. Results saved to $ksstrike_results_file"

# Run Gxss on collected URLs
run_command "gxss -u $wayback_urls_file -p payloads.txt > $gxss_results_file"
echo "[+] Gxss scan completed. Results saved to $gxss_results_file"

echo "[*] XSS scanning completed!"
