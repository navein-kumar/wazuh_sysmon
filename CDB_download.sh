#!/bin/bash
curl https://lists.blocklist.de/lists/all.txt | grep -P '\d+.\d+.\d+.\d+' | sed 's/$/:/g' > blocklist-ip &&
#curl https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/alienvault_reputation.ipset | grep -v '^#' | sed 's/$/:/g' > blocklist-ip
curl https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/pro.plus-onlydomains.txt | grep -v '^#' | sed 's/$/:/g' > blocklist-domain &&
#linux_hash
curl https://virusshare.com/hashfiles/unpacked_hashes.md5 | grep -P '\w{32}' | sed -e 'y/ /\n/' | sed -r '/^\s*$/d' | sed -ne 's/.*/MD5=&/p' | sed 's/$/:/g' > blocklist-hash1 &&
#windows_hash
curl https://virusshare.com/hashfiles/unpacked_hashes.md5 | grep -P '\w{32}' | sed -e 'y/ /\n/' | sed -r '/^\s*$/d' | sed -ne 's/.*/MD5=&/p' | sed -e 's/\(.*\)/\U\1/' | sed 's/$/:/g' > blocklist-hash &&
chown -R --reference=audit-keys blocklist-ip blocklist-domain blocklist-hash blocklist-hash1 &&
chmod -R --reference=audit-keys blocklist-ip blocklist-domain blocklist-hash blocklist-hash1 &&
docker restart single-node_wazuh.manager_1
