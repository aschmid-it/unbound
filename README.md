# unbound - Unbound DNS
This is a transcript and/or step-by-step guide of setting up an Unbound DNS server for a home or small business environment.

## Install
- Install: `sudo apt install unbound`
- Setup primary root DNS Servers (root.hints)
    - Unbound has a list in it's code but it's good to update every six months
    - Get latest root-hints: `curl -Lo /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache`
    - Change owner: `chown unbound:unbound /var/lib/unbound/root.hints`
- Setup certificate for DNSSEC (root.key) (Note: might have be done by installer already)
	- Get auto-trust-anchor for DNSSEC: 
	```shell
    unbound-anchor -a /var/lib/unbound/root.key
    chown unbound:unbound /var/lib/unbound/root.key
    chmod 500 /var/lib/unbound/root.key
    ```
	    - Check: `unbound-anchor -l` 
- Optional: start unbound control: `unbound-control start`

## Logfile
- If using a logfile first create:
```
mkdir /var/log/unbound
chown unbound:unbound /var/log/unbound/
touch /var/log/unbound/unbound.log
chown unbound:unbound /var/log/unbound/unbound.log
```
- Then fix appamor: `vi /etc/apparmor.d/local/usr.sbin.unbound`
    ```
    # Site-specific additions and overrides for usr.sbin.unbound.
    # For more details, please see /etc/apparmor.d/local/README.
    /var/log/unbound/unbound.log rw,
    ```
- Parse new config: `apparmor_parser -r /etc/apparmor.d/usr.sbin.unbound`
- Restart: `systemctl restart unbound`

### Logfile rotation
- Make sure the config file contains:
```
logfile: /var/log/unbound.log
log-queries: yes
```
- Rotate logs via logrotate
- Create file: `/etc/logrotate.d/unbound`
```
# A Schmid IT - Rotate unbound logs
/var/log/unbound/unbound.log {
    daily
    rotate 90
    misingok
    notifempty
    # compress
    # delaycompress
    sharedscripts
    create 644 unbound unbound
    postrotate
        /usr/sbin/unbound-control log_reopen
    endscript
}
```
- Check: `logrotate /etc/logrotate.conf --debug`

### Logfile Syntax
```
<!-- queries -->
<rule id="unbound-query" class='system' provider='syslog-ng'>
  <patterns>
    <pattern>@ESTRING:PID: @@ESTRING:SEVERITY: @@ESTRING:CLIENTIP: @@ESTRING:NAME: @@ESTRING:TYPE: @@ESTRING:CLASS: @@ESTRING:RETURN_CODE: @@FLOAT:TIME_TO_RESOLVE:@ @NUMBER:FROM_CACHE:@ @NUMBER:RESPONSE_SIZE:@</pattern>
  </patterns>
  <tags><tag>query</tag></tags>
</rule>
(...)
<!-- redirect queries (AD Blocklists) -->
<rule id="unbound-redirect" class='system' provider='syslog-ng'>
  <patterns>
    <pattern>@ESTRING:PID: @@ESTRING:SEVERITY: @@ESTRING:NAME: @redirect @IPvANY:CLIENTIP:@@@@NUMBER:PORT:@ @ESTRING:NAME: @@ESTRING:TYPE: @@STRING:CLASS:@</pattern>
  </patterns>
  <tags><tag>redirect</tag></tags>
</rule>
```

