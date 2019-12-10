# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="Proxy DNS server with permanent caching"
HOMEPAGE="http://members.home.nl/p.a.rombouts/pdnsd/"
SRC_URI="http://members.home.nl/p.a.rombouts/pdnsd/releases/${P}-par.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~s390 ~sparc ~x86"
IUSE="debug ipv6 isdn +urandom test"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/pdnsd
	acct-user/pdnsd
"
DEPEND="test? ( net-dns/bind-tools )"

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/pdnsd
		--with-cachedir="${EPREFIX}"/var/cache/pdnsd
		--with-default-id=pdnsd
		$(use_enable ipv6)
		$(use_enable ipv6 ipv6-startup)
		$(use_enable isdn)
		$(usex debug '--with-debug=3' '')
		$(usex urandom "--with-random-device=${EPREFIX}/dev/urandom" '')
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	local DOCS=( AUTHORS ChangeLog* NEWS README THANKS TODO README.par )
	default

	docinto contrib
	dodoc contrib/{README,dhcp2pdnsd,pdnsd_dhcp.pl}

	docinto html
	dodoc doc/html/*
	docinto txt
	dodoc doc/txt/*
	newdoc doc/pdnsd.conf pdnsd.conf.sample

	newinitd "${FILESDIR}/pdnsd.rc8" pdnsd
	newconfd "${FILESDIR}/pdnsd.confd" pdnsd
	newinitd "${FILESDIR}/pdnsd.online.2" pdnsd-online
	newconfd "${FILESDIR}/pdnsd-online.confd" pdnsd-online
	systemd_newtmpfilesd "${FILESDIR}/pdnsd.tmpfiles" pdnsd.conf
	systemd_dounit "${FILESDIR}/pdnsd.service"
}

src_test() {
	fail_kill() {
		kill -9 $(<"${T}"/pid)
		die "$1"
	}

	mkdir "${T}/pdnsd" || die
	echo -n -e "pd12\0\0\0\0" > "${T}/pdnsd/pdnsd.cache"
	IPS="$(grep ^nameserver /etc/resolv.conf | sed -e 's/nameserver \(.*\)/\tip=\1;/g' | xargs)"
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
	local cachedir="${EPREFIX}/var/cache/pdnsd"
	if [[ ! -d "${cachedir}" ]] ; then
		mkdir "${cachedir}" || eerror "Failed to create cache"
	fi
	chown pdnsd:pdnsd "${cachedir}" \
		|| eerror "Failed to set ownership for cachedir"
	chmod 0750 "${cachedir}" \
		|| eerror "Failed to set permissions for cachedir"
}
