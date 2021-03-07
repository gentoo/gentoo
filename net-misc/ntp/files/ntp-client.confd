# /etc/conf.d/ntp-client

# Command to run to set the clock initially
# Most people should just leave this line alone ...
# however, if you know what you're doing, and you
# want to use ntpd to set the clock, change this to 'ntpd'
NTPCLIENT_CMD="ntpdate"

# Options to pass to the above command
# This default setting should work fine but you should
# change the default 'pool.ntp.org' to something closer
# to your machine.  See http://www.pool.ntp.org/ or
# try running `netselect -s 3 pool.ntp.org`.
NTPCLIENT_OPTS="-s -b -u \
	0.gentoo.pool.ntp.org 1.gentoo.pool.ntp.org \
	2.gentoo.pool.ntp.org 3.gentoo.pool.ntp.org"

# If you use hostnames above, then you should depend on dns
# being up & running before we try to run.  Otherwise, you
# can disable this.
rc_use="dns"
