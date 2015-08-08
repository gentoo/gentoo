# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit systemd user

DESCRIPTION="Proxy DNS server with permanent caching"
HOMEPAGE="http://members.home.nl/p.a.rombouts/pdnsd/"
SRC_URI="http://members.home.nl/p.a.rombouts/pdnsd/releases/${P}-par.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ~s390 sparc x86"
IUSE="debug ipv6 isdn +urandom test"

RDEPEND=""
DEPEND="test? ( net-dns/bind-tools )"

pkg_setup() {
	enewgroup pdnsd
	enewuser pdnsd -1 -1 /var/lib/pdnsd pdnsd
}

src_configure() {
	local myconf=""
	use debug && myconf="${myconf} --with-debug=3"
	use urandom && myconf="${myconf} --with-random-device=/dev/urandom"

	econf \
		--disable-dependency-tracking \
		--sysconfdir=/etc/pdnsd \
		--with-cachedir=/var/cache/pdnsd \
		--with-default-id=pdnsd \
		$(use_enable ipv6) $(use_enable ipv6 ipv6-startup) \
		$(use_enable isdn) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog* NEWS README THANKS TODO README.par
	docinto contrib ; dodoc contrib/{README,dhcp2pdnsd,pdnsd_dhcp.pl}
	docinto html ; dohtml doc/html/*
	docinto txt ; dodoc doc/txt/*
	newdoc doc/pdnsd.conf pdnsd.conf.sample

	newinitd "${FILESDIR}/pdnsd.rc8" pdnsd
	newinitd "${FILESDIR}/pdnsd.online.2" pdnsd-online
	systemd_newtmpfilesd "${FILESDIR}/pdnsd.tmpfiles" pdnsd.conf
	systemd_dounit "${FILESDIR}/pdnsd.service"

	mkdir "${T}"/confd || die

	cat - > "${T}"/confd/pdnsd-online <<EOF
# Make sure to change the rc_need variable to the service for the
# interface that connects you to the dns servers.
#
# For instance if you use a PPP connection on ppp0 to connect, set
#   rc_need="net.ppp0"

rc_need="net.lo"
EOF

	# Don't try to do the smart thing and add the --help output here:
	# it will cause the file to be etc-updated if the help text
	# changes and fails when cross-compiling.
	cat - > "${T}"/confd/pdnsd <<EOF
# Command line options, check pdnsd --help for a list of valid
# parameters. Note that most of the options that can be given at
# command-line are also available as configuration parameters in
# /etc/pdnsd/pdnsd.conf
PDNSDCONFIG=""
EOF

	doconfd "${T}"/confd/*

	# gentoo resolvconf support
	exeinto /etc/resolvconf/update.d
	newexe "${FILESDIR}/pdnsd.resolvconf-r1" pdnsd
}

src_test() {
	fail_kill() {
		kill -9 $(<"${T}"/pid)
		die "$1"
	}

	mkdir "${T}/pdnsd" || die
	echo -n -e "pd12\0\0\0\0" > "${T}/pdnsd/pdnsd.cache"
	IPS=$(grep ^nameserver /etc/resolv.conf | sed -e 's/nameserver \(.*\)/\tip=\1;/g' | xargs)
	sed -e "s/\tip=/${IPS}/" -e "s:cache_dir=:cache_dir=${T}/pdnsd:" "${FILESDIR}/pdnsd.conf.test" \
		> "${T}/pdnsd.conf.test"
	src/pdnsd -c "${T}/pdnsd.conf.test" -g -s -d -p "${T}/pid" || die "couldn't start daemon"
	sleep 3

	find "${T}" -ls
	[ -s "${T}/pid" ] || die "empty or no pid file created"
	[ -S "${T}/pdnsd/pdnsd.status" ] || fail_kill "no socket created"
	src/pdnsd-ctl/pdnsd-ctl -c "${T}/pdnsd" server all up || fail_kill "failed to start the daemon"
	src/pdnsd-ctl/pdnsd-ctl -c "${T}/pdnsd" status || fail_kill "failed to communicate with the daemon"
	sleep 3

	dig @127.0.0.1 -p 33455 localhost > "${T}"/dig.output 2>&1
	cat "${T}"/dig.output || die
	fgrep -q "status: NOERROR" "${T}"/dig.output || fail_kill "www.gentoo.org lookup failed"

	kill $(<"${T}/pid") || fail_kill "failed to terminate daemon"
}

pkg_postinst() {
	elog
	elog "Add pdnsd to your default runlevel - rc-update add pdnsd default"
	elog ""
	elog "Add pdnsd-online to your online runlevel."
	elog "The online interface will be listed in /etc/conf.d/pdnsd-online"
	elog ""
	elog "Sample config file in /etc/pdnsd/pdnsd.conf.sample"

	# The tmpfiles.d configuration does not come into effect before the
	# next reboot so create the cachedir now.
	local cachedir="/var/cache/pdnsd"
	if [[ ! -d ${cachedir} ]] ; then
		mkdir ${cachedir} || eerror "Failed to create cache"
	fi
	chown pdnsd:pdnsd ${cachedir} \
		|| eerror "Failed to set ownership for cachedir"
	chmod 0750 ${cachedir} \
		|| eerror "Failed to set permissions for cachedir"
}
