# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils user

DESCRIPTION="Network backup and restore client and server for Unix and Windows"
HOMEPAGE="http://burp.grke.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="acl afs ipv6 nls ssl tcpd xattr"

DEPEND="
	dev-libs/uthash
	sys-libs/libcap
	net-libs/librsync
	sys-libs/ncurses
	sys-libs/zlib
	acl? ( sys-apps/acl )
	afs? ( net-fs/openafs )
	nls? ( sys-devel/gettext )
	ssl? ( dev-libs/openssl:0 )
	tcpd? ( sys-apps/tcp-wrappers )
	xattr? ( sys-apps/attr )
	"
RDEPEND="${DEPEND}
	virtual/logger
	"

DOCS=( CONTRIBUTORS DONATIONS UPGRADING )
PATCHES=(
	"${FILESDIR}/${PV}-bedup-conf-path.patch"
	"${FILESDIR}/${PV}-tinfo.patch"
	)

pkg_setup() {
	enewgroup "${PN}"
	enewuser "${PN}" -1 "" "" "${PN}"
}

src_prepare() {
	epatch "${PATCHES[@]}"
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--sbindir=/usr/sbin
		--sysconfdir=/etc/burp
		--enable-largefile
		$(use_with ssl openssl)
		$(use_enable acl)
		$(use_enable afs)
		$(use_enable ipv6)
		$(use_enable nls)
		$(use_enable xattr)
		$(use_with tcpd tcp-wrappers)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	fowners root:burp /etc/burp /var/spool/burp
	fperms 0775 /etc/burp /var/spool/burp
	fowners root:burp /etc/burp/clientconfdir
	fperms 0750 /etc/burp/clientconfdir
	fowners root:burp /etc/burp/burp-server.conf
	fperms 0640 /etc/burp/burp-server.conf

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	dodoc docs/*

	sed -e 's|^# user=graham|user = burp|' \
		-e 's|^# group=nogroup|group = burp|' \
		-e 's|^pidfile = .*|lockfile = /run/lock/burp/server.lock|' \
		-i "${D}"/etc/burp/burp-server.conf || die
}

pkg_postinst() {
	if use ssl && [ ! -e /etc/burp/CA/index.txt ]; then
		elog "At first run burp server will generate DH parameters and SSL"
		elog "certificates.  You should adjust configuration before."
		elog "Server configuration is located at"
		elog ""
		elog "  /etc/burp/burp-server.conf"
		elog ""
	fi
}
