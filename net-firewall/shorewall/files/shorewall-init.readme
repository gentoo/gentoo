shorewall-init from upstream offers two features (taken from [1]):

	1. It can 'close' the firewall before the network interfaces are
	   brought up during boot.
	
	2. It can change the firewall state as the result of interfaces
	   being brought up or taken down.

On Gentoo we only support the first feature -- the firewall lockdown during
boot.

We do not support the second feature, because Gentoo doesn't support a
if-{up,down}.d folder like other distributions do. If you would want to use
such a feature, you would have to add a custom action to /etc/conf.d/net
(please refer to the Gentoo Linux Handbook [2] for more information).
If you are able to add your custom {pre,post}{up,down} action, your are
also able to specify what shorewall{6,-lite,6-lite} should do, so there is
no need for upstream's scripts in Gentoo.

If you disagree with us, feel free to open a bug [3] and contribute your
solution for Gentoo.

Upstream's original init script also supports saving and restoring of
ipsets. Please use the init script from net-firewall/ipset if you need
such a feature.


[1] http://www.shorewall.net/Shorewall-init.html
[2] http://www.gentoo.org/doc/en/handbook/handbook-x86.xml?part=4&chap=5
[3] https://bugs.gentoo.org
