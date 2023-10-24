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
