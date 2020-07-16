# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="Network backup and restore client and server for Unix and Windows"
HOMEPAGE="https://burp.grke.org/"
SRC_URI="https://github.com/grke/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="acl ipv6 libressl test xattr"

RESTRICT="!test? ( test )"

CDEPEND=" acct-group/burp
	acct-user/burp
	dev-libs/uthash
	net-libs/librsync
	sys-libs/ncurses:0=
	sys-libs/zlib
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	acl? ( sys-apps/acl )
	xattr? ( sys-apps/attr )"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	test? ( dev-libs/check )"
RDEPEND="${CDEPEND}
	virtual/logger"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.20-no_mkdir_run.patch
	"${FILESDIR}"/${PN}-2.1.20-protocol1_by_default.patch
	"${FILESDIR}"/${PN}-2.0.54-server_user.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--localstatedir=/var
		--sysconfdir=/etc/burp
		--enable-largefile
		$(use_enable acl)
		$(use_enable ipv6)
		$(use_enable xattr)
	)
	# --runstatedir option will only work from autoconf-2.70 onwards
	runstatedir='/run' \
		econf "${myeconfargs[@]}"
}

src_install() {
	default
	keepdir /var/spool/burp
	fowners -R root:${PN} /var/spool/burp
	fperms 0770 /var/spool/burp

	emake DESTDIR="${D}" install-configs
	fowners -R root:${PN} /etc/burp
	fperms 0750 /etc/burp
	fperms 0640 /etc/burp/burp-server.conf
	fperms 0750 /etc/burp/clientconfdir

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_postinst() {
	elog "Burp ebuilds now support the autoupgrade mechanism in both"
	elog "client and server mode. In both cases it is disabled by"
	elog "default. You almost certainly do NOT want to enable it in"
	elog "client mode because upgrades obtained this way will not be"
	elog "managed by Portage."

	if [[ ! -e /etc/burp/CA/index.txt ]]; then
		elog ""
		elog "At first run burp server will generate DH parameters and SSL"
		elog "certificates.  You should adjust configuration before."
		elog "Server configuration is located at"
		elog ""
		elog "  /etc/burp/burp-server.conf"
		elog ""
	fi

	# According to PMS this can be a space-separated list of version
	# numbers, even though in practice it is typically just one.
	local oldver
	for oldver in ${REPLACING_VERSIONS}; do
		if [[ $(ver_cut 1 ${oldver}) -lt 2 ]]; then
			ewarn "Starting with version 2.0.54 we no longer patch bedup to use"
			ewarn "the server config file by default. If you use bedup, please"
			ewarn "update your scripts to invoke it as"
			ewarn ""
			ewarn "  bedup -c /etc/burp/burp-server.conf"
			ewarn ""
			ewarn "Otherwise deduplication will not work!"
			break
		fi
	done
}
