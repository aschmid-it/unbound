#!/bin/sh
# A Schmid IT - Update root hints and pull any blocklists

# Get the root hints
curl https://www.internic.net/domain/named.cache -o /var/lib/unbound/root.hints
chown unbound:unbound /var/lib/unbound/root.hints

# Get the blacklist updates

# Hand brush - Cleans the Internet and protects your privacy! Blocks Ads, Tracking, Metrics, some Malware and Fake.
curl https://raw.githubusercontent.com/hagezi/dns-blocklists/main/unbound/light.blacklist.conf -o /etc/unbound/unbound.conf.d/light.blacklist.conf

# Remove all whitelisted entries from the list
grep -vf ./whitelist.txt /etc/unbound/unbound.conf.d/light.blacklist.conf > /etc/unbound/unbound.conf.d/light.blacklist.wl.conf
rm /etc/unbound/unbound.conf.d/light.blacklist.conf

# Options

# Broom - Cleans the Internet and protects your privacy! Blocks Ads, Affiliate, Tracking, Metrics, Telemetry, Phishing, Malware, Scam, Fake, Coins and other "Crap".
# curl https://raw.githubusercontent.com/hagezi/dns-blocklists/main/unbound/multi.blacklist.conf -o /etc/unbound/unbound.conf.d/multi.blacklist.conf

# Big broom - Cleans the Internet and protects your privacy! Blocks Ads, Affiliate, Tracking, Metrics, Telemetry, Phishing, Malware, Scam, Fake, Coins and other "Crap".
# curl https://raw.githubusercontent.com/hagezi/dns-blocklists/main/unbound/pro.blacklist.conf -o /etc/unbound/unbound.conf.d/pro.blacklist.conf

# Sweeper - Aggressive cleans the Internet and protects your privacy! Blocks Ads, Affiliate, Tracking, Metrics, Telemetry, Phishing, Malware, Scam, Fake, Coins and other "Crap".
# More aggressive version of the Multi PRO blocklist. It may contain false positive domains that limit functionality. Therefore it should only be used by experienced users. Furthermore, an admin should be available to unblock incorrectly blocked domains.
# curl https://raw.githubusercontent.com/hagezi/dns-blocklists/main/unbound/pro.plus.blacklist.conf -o /etc/unbound/unbound.conf.d/pro.plus.blacklist.conf

# Additional blacklists

# Fake - Protect against internet scams, traps and fakes
# curl https://raw.githubusercontent.com/hagezi/dns-blocklists/main/unbound/fake.blacklist.conf -o /etc/unbound/unbound.conf.d/fake.blacklist.conf

# Threat Intelligence Feeds
# curl https://raw.githubusercontent.com/hagezi/dns-blocklists/main/unbound/tif.blacklist.conf -o /etc/unbound/unbound.conf.d/tif.blacklist.conf

# Relaod unbound
/usr/sbin/unbound-control reload
