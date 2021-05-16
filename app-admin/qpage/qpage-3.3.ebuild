# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Sends messages to an alphanumeric pager via TAP protocol"
HOMEPAGE="http://www.qpage.org/"
SRC_URI="http://www.qpage.org/download/${P}.tar.Z"

LICENSE="qpage"
SLOT="0"
KEYWORDS="~alpha amd64 x86"
IUSE="tcpd"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )"
RDEPEND="${DEPEND}
	virtual/mta"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-fix-warning.patch
	"${FILESDIR}"/${P}-fix-build-system.patch
)

src_configure() {
	tc-export CC
	default

	# There doesn't seem to be a clean way to disable tcp wrappers in
	# this package if you have it installed, but don't want to use it.
	if ! use tcpd ; then
		sed -i 's/-lwrap//g; s/-DTCP_WRAPPERS//g' Makefile || die
		echo '#undef TCP_WRAPPERS' >> config.h || die
	fi
}

src_install() {
	default

	dodir /var/spool/qpage
	fowners daemon:daemon /var/spool/qpage
	fperms 770 /var/spool/qpage

	dodir /var/lock/subsys/qpage
	fowners daemon:daemon /var/lock/subsys/qpage
	fperms 770 /var/lock/subsys/qpage

	insinto /etc/qpage
	doins example.cf

	doinitd "${FILESDIR}"/qpage
}

pkg_postinst() {
	elog
	elog "Post-installation tasks:"
	elog
	elog "1. Create /etc/qpage/qpage.cf (see example.cf in that dir)."
	elog "2. Insure that the serial port selected in qpage.cf"
	elog "   is writable by user or group daemon."
	elog "3. Set automatic startup with rc-update add qpage default"
	elog "4. Send mail to tomiii@qpage.org telling him how"
	elog "   you like qpage! :-)"
	elog
}
