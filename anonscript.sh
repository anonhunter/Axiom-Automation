!/bin/bash

echo "Running axiom-fleet..." | notify 
axiom-fleet -i 20
echo "axiom-fleet created successfully" | notify

echo "Running axiom-scan for subdomain enumeration by subfinder now..." | notify
axiom-scan subdomains.txt -m subfinder -all -o subfin.txt 
echo "axiom-scan for subdomain enumeration completed." | notify

echo "Running axiom-scan for subdomain enumeration by Amass now..." | notify 
axiom-scan subdomains.txt -m amass enum -passive -o amas.txt 
echo "axiom-scan for subdomain enumeration completed." | notify

echo "Merging both the Subdomain files" | notify
cat subfin.txt amas.txt | sort -u › subs. txt
echo "Both subdomains file merged Successfully" | notify

echo "Running axiom-scan for GAU Module" | notify 
axiom-scan subs.txt -m gau -o gau.txt
echo "axiom-scan for GAU Module Completed" | notify

echo "Running axiom-scan for Katana..." | notify 
axiom-scan subs.txt -m katana -o katana.txt 
echo "axiom-scan for Katana completed..." | notify

echo "Merging URL/endpoints file GAU and Katana" | notify
cat gau.txt katana.txt | sort -u › urls.txt
echo "URL/Endpoints Files from GAU and Katana Merged successfully." | notify

echo "Filtering Backup files" | notify
cat urls.txt | grep -E "\. (backup|zip|tar|db)$" | anew › backup.txt
echo "Backup files Filtered Successfully" | notify

echo "Filtering Js and Json files." | notify
cat urls. txt | grep -E "\. (js|json)$" | anew › files2.txt
echo "Filter process completed..." | notify

echo "Runniing Axiom-scan for httpx probing for sensitive keywords response.." | notify 
axion-scan files2.txt -m httpx-silent -sr 'secret|password|admin|api_key|token' -o httpx_js.txt
echo "Httpx probing completed (for sensitive keywords)" | notify 

echo "Running Axiom-Scan for HTTPx Probing.. (full)" | notify 
axiom-scan subs.txt -m httpx -o httpx.txt
echo "Axiom-Scan for full HTTPx probing Completed" | notify

echo "Running Axiom-Scan for Nuclei..." | notify 
axiom-scan httpx.txt -m nuclei --severity medium, high, critical -o nuclei. txt --rm-when-done
echo "Nuclei scan completed now, deleted all the axiom Fleets too" | notify 

echo "Going into sleep mode now, see you in ETA 30h" | notify 
sleep 216000 # 60 hours in seconds done
