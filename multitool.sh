#!/bin/bash

# Function to display the poster with effects
show_poster() {
    clear
    echo -e "\e[1;36m"
    echo "   ███╗   ███╗██╗   ██╗██╗  ████████╗██╗████████╗ ██████╗  ██████╗ ██╗"
    echo "   ████╗ ████║██║   ██║██║  ╚══██╔══╝██║╚══██╔══╝██╔═══██╗██╔═══██╗██║"
    echo "   ██╔████╔██║██║   ██║██║     ██║   ██║   ██║   ██║   ██║██║   ██║██║"
    echo "   ██║╚██╔╝██║██║   ██║██║     ██║   ██║   ██║   ██║   ██║██║   ██║██║"
    echo "   ██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║   ██║   ╚██████╔╝╚██████╔╝███████╗"
    echo "   ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝   ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝"
    echo -e "\e[1;35m"
    echo "                          - BY SARTHAK JOSHI"
    echo -e "\e[0m"
    sleep 2
}

show_menu() {
    echo -e "\e[1;32m===== Multi-Uses Tool =====\e[0m"
    echo -e "\e[1;34m1. Cryptography (AES Encryption/Decryption)\e[0m"
    echo -e "\e[1;34m2. Steganography (Hide/Extract Data in Image)\e[0m"
    echo -e "\e[1;34m3. Wi-Fi Hacking (Capture Handshake)\e[0m"
    echo -e "\e[1;34m4. Wi-Fi Password Cracking\e[0m"
    echo -e "\e[1;34m5. Nmap Scanning\e[0m"
    echo -e "\e[1;34m6. Whois Lookup\e[0m"
    echo -e "\e[1;34m7. Password Cracking (John the Ripper)\e[0m"
    echo -e "\e[1;31m8. Exit\e[0m"
}

# Function for AES encryption
encrypt_aes() {
    read -p "Enter plaintext: " plaintext
    read -p "Enter AES key (16/24/32 bytes): " key
    echo -n "$plaintext" | openssl enc -aes-256-cbc -a -salt -pass pass:"$key"
    echo
}

decrypt_aes() {
    read -p "Enter ciphertext: " ciphertext
    read -p "Enter AES key (16/24/32 bytes): " key
    echo "$ciphertext" | openssl enc -d -aes-256-cbc -a -salt -pass pass:"$key"
    echo
}

hide_data() {
    read -p "Enter image path: " image_path
    read -p "Enter file to hide: " data_file
    steghide embed -cf "$image_path" -ef "$data_file" -sf output_stego_image.jpg
    echo "[*] Data hidden in output_stego_image.jpg"
}

extract_data() {
    read -p "Enter stego image path: " image_path
    steghide extract -sf "$image_path" -xf extracted_data.txt
    echo "[*] Data extracted to extracted_data.txt"
}

wifi_hacking() {
    read -p "Enter wireless interface (e.g., wlan0): " interface

    # Check for and kill interfering processes
    echo "[*] Checking for and killing interfering processes..."
    sudo airmon-ng check kill

    # Enable monitor mode
    echo "[*] Enabling monitor mode on $interface..."
    sudo airmon-ng start "$interface"
    interface="${interface}"  
    echo "[*] Monitor mode enabled on $interface."

    # Start scanning for nearby Wi-Fi networks
    echo "[*] Scanning for nearby Wi-Fi networks. Press Ctrl+C to stop scanning when you see your target ESSID."
    sudo airodump-ng "$interface"

    # Prompt user for target ESSID and channel
    read -p "Enter the target ESSID (Wi-Fi name): " target_essid
    read -p "Enter the target channel (e.g., 6): " target_channel

    # Prompt user for output file name
    read -p "Enter the name for the output .cap file (e.g., handshake): " output_file

    # Start targeted capture
    echo "[*] Starting targeted capture on $target_essid (Channel $target_channel)..."
    echo "[*] Press Ctrl+C to stop capturing when the handshake is captured."
    sudo airodump-ng -c "$target_channel" --essid "$target_essid" -w "$output_file" --output-format cap "$interface"

    echo "[*] Capture completed. Handshake saved to ${output_file}-01.cap"
}

wifi_password_cracking() {
    read -p "Enter path to handshake file (e.g., capture.cap): " handshake_file
    read -p "Enter path to wordlist (e.g., wordlist.txt): " wordlist
    echo "[*] Starting Wi-Fi password cracking..."
    aircrack-ng "$handshake_file" -w "$wordlist"
}

nmap_scan() {
    echo -e "\e[1;32m===== Nmap Scanning =====\e[0m"
    echo -e "\e[1;34m1. Host Discovery\e[0m"
    echo -e "\e[1;34m2. Target Specification\e[0m"
    echo -e "\e[1;34m3. OS Detection\e[0m"
    echo -e "\e[1;34m4. Port Specification\e[0m"
    echo -e "\e[1;34m5. Service and Version Detection\e[0m"
    echo -e "\e[1;34m6. Scan Techniques\e[0m"
    echo -e "\e[1;31m7. Back to Main Menu\e[0m"
    read -p "Enter your choice: " nmap_choice

    case "$nmap_choice" in
        1)
            read -p "Enter network range (e.g., 192.168.1.0/24): " network_range
            echo "[*] Starting host discovery on $network_range..."
            nmap -sn "$network_range" -oN host_discovery.txt
            echo "[*] Host discovery completed. Results saved to host_discovery.txt"
            ;;
        2)
            read -p "Enter target IP or range (e.g., 192.168.1.1 or 192.168.1.1-100): " target
            echo "[*] Scanning target $target..."
            nmap "$target" -oN target_scan.txt
            echo "[*] Target scan completed. Results saved to target_scan.txt"
            ;;
        3)
            read -p "Enter target IP or range: " target
            echo "[*] Detecting OS for $target..."
            nmap -O "$target" -oN os_detection.txt
            echo "[*] OS detection completed. Results saved to os_detection.txt"
            ;;
        4)
            read -p "Enter target IP or range: " target
            read -p "Enter ports to scan (e.g., 80,443 or 1-1000): " ports
            echo "[*] Scanning ports $ports on $target..."
            nmap -p "$ports" "$target" -oN port_scan.txt
            echo "[*] Port scan completed. Results saved to port_scan.txt"
            ;;
        5)
            read -p "Enter target IP or range: " target
            echo "[*] Detecting services and versions on $target..."
            nmap -sV "$target" -oN service_version_detection.txt
            echo "[*] Service and version detection completed. Results saved to service_version_detection.txt"
            ;;
        6)
            echo -e "\e[1;32m===== Scan Techniques =====\e[0m"
            echo -e "\e[1;34m1. SYN Scan\e[0m"
            echo -e "\e[1;34m2. TCP Connect Scan\e[0m"
            echo -e "\e[1;34m3. UDP Scan\e[0m"
            read -p "Enter your choice: " scan_choice
            read -p "Enter target IP or range: " target

            case "$scan_choice" in
                1)
                    echo "[*] Starting SYN scan on $target..."
                    nmap -sS "$target" -oN syn_scan.txt
                    echo "[*] SYN scan completed. Results saved to syn_scan.txt"
                    ;;
                2)
                    echo "[*] Starting TCP Connect scan on $target..."
                    nmap -sT "$target" -oN tcp_connect_scan.txt
                    echo "[*] TCP Connect scan completed. Results saved to tcp_connect_scan.txt"
                    ;;
                3)
                    echo "[*] Starting UDP scan on $target..."
                    nmap -sU "$target" -oN udp_scan.txt
                    echo "[*] UDP scan completed. Results saved to udp_scan.txt"
                    ;;
                *)
                    echo "Invalid choice!"
                    ;;
            esac
            ;;
        7)
            return
            ;;
        *)
            echo "Invalid choice!"
            ;;
    esac
}

whois_lookup() {
    read -p "Enter domain or IP address: " target
    echo "[*] Performing Whois lookup for $target..."
    whois "$target" | tee whois_lookup.txt
    echo "[*] Whois lookup completed. Results saved to whois_lookup.txt"
}

password_cracking() {
    read -p "Enter path to the password file (e.g., hashes.txt): " password_file
    read -p "Enter path to the wordlist (e.g., wordlist.txt): " wordlist
    echo "[*] Starting password cracking with John the Ripper..."
    john --wordlist="$wordlist" "$password_file"
    echo "[*] Password cracking completed. Results displayed above."
}

show_poster
while true; do
    show_menu
    read -p "Enter your choice: " choice

    case "$choice" in
        1)
            echo "===== Cryptography ====="
            read -p "Choose action (encrypt/decrypt): " action
            if [[ "$action" == "encrypt" ]]; then
                encrypt_aes
            elif [[ "$action" == "decrypt" ]]; then
                decrypt_aes
            else
                echo "Invalid action!"
            fi
            ;;
        2)
            echo "===== Steganography ====="
            read -p "Choose action (hide/extract): " action
            if [[ "$action" == "hide" ]]; then
                hide_data
            elif [[ "$action" == "extract" ]]; then
                extract_data
            else
                echo "Invalid action!"
            fi
            ;;
        3)
            echo "===== Wi-Fi Hacking ====="
            wifi_hacking
            ;;
        4)
            echo "===== Wi-Fi Password Cracking ====="
            wifi_password_cracking
            ;;
        5)
            nmap_scan
            ;;
        6)
            echo "===== Whois Lookup ====="
            whois_lookup
            ;;
        7)
            echo "===== Password Cracking ====="
            password_cracking
            ;;
        8)
            echo "[*] Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice! Please try again."
            ;;
    esac
done
