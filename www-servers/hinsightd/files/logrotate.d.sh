/var/log/hinsightd/*.log {
daily
missingok
rotate 7
compress
delaycompress
minsize 1M
notifempty
sharedscripts
postrotate
	test -e /run/openrc/softlevel && /etc/init.d/hinsightd reload 1>/dev/null || true
	test -e /run/systemd/system && systemctl reload hinsightd.service || true
endscript
}
