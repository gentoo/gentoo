# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils user

DESCRIPTION="Network backup and restore client and server for Unix and Windows"
HOMEPAGE="http://burp.grke.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	http://burp.grke.org/downloads/${P}/${P}.tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acl afs ipv6 libressl nls tcpd xattr"

DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	dev-libs/uthash
	sys-libs/libcap
	~net-libs/librsync-0.9.7
	sys-libs/ncurses:0=
	sys-libs/zlib
	acl? ( sys-apps/acl )
	afs? ( net-fs/openafs )
	nls? ( sys-devel/gettext )
	tcpd? ( sys-apps/tcp-wrappers )
	xattr? ( sys-apps/attr )
	"
RDEPEND="${DEPEND}
	virtual/logger
	"

DOCS=( CONTRIBUTORS DONATIONS UPGRADING )
PATCHES=(
	"${FILESDIR}/${PV}-non-zero-or-build-failure.patch"
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
	sed -e '/autoupgrade/d' -i "${S}"/Makefile.in || die
	rm "${S}"/docs/autoupgrade.txt || die
}

src_configure() {
	local myeconfargs=(
		--sbindir=/usr/sbin
		--sysconfdir=/etc/burp
		--enable-largefile
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

	fowners root:burp /etc/burp
	fperms 0775 /etc/burp
	fowners root:burp /etc/burp/burp-server.conf
	fperms 0640 /etc/burp/burp-server.conf
	fowners root:burp /etc/burp/clientconfdir
	fperms 0750 /etc/burp/clientconfdir
	fowners root:burp /var/spool/burp
	fperms 0770 /var/spool/burp

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	dodoc docs/*

	local scripts_dir=/usr/share/burp/scripts
	dodir "${scripts_dir}"
	local script
	for script in notify_script ssl_extra_checks_script summary_script \
			timer_script; do
		mv "${D}etc/burp/${script}" "${D}${scripts_dir}/" || die
		sed -r \
			-e "s|(=\\s*)/etc/burp/${script}\\s*$|\1${scripts_dir}/${script}|" \
			-i "${D}etc/burp/burp-server.conf" \
			|| die
	done

	sed -e '/autoupgrade/d' -i "${D}etc/burp/burp.conf" || die
	sed -e '/autoupgrade/,+1d' -i "${D}etc/burp/burp-server.conf" || die

	sed -e 's|^# user=graham|user = burp|' \
		-e 's|^# group=nogroup|group = burp|' \
		-e 's|^pidfile = .*|lockfile = /run/lock/burp/server.lock|' \
		-i "${D}etc/burp/burp-server.conf" || die
}

pkg_postinst() {
	if [[ ! -e /etc/burp/CA/index.txt ]]; then
		elog "At first run burp server will generate DH parameters and SSL"
		elog "certificates.  You should adjust configuration before."
		elog "Server configuration is located at"
		elog ""
		elog "  /etc/burp/burp-server.conf"
		elog ""
	fi
}
