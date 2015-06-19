# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/qpage/qpage-3.3.ebuild,v 1.7 2014/08/10 01:37:39 patrick Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Sends messages to an alphanumeric pager via TAP protocol"
HOMEPAGE="http://www.qpage.org/"
SRC_URI="http://www.qpage.org/download/${P}.tar.Z"

LICENSE="qpage"
SLOT="0"
KEYWORDS="alpha amd64 x86"
IUSE="tcpd"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )"
RDEPEND="${DEPEND}
	virtual/mta"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-fix-warning.patch
}

src_compile() {
	tc-export CC
	econf || die "econf failed"

	# There doesn't seem to be a clean way to disable tcp wrappers in
	# this package if you have it installed, but don't want to use it.
	if ! use tcpd ; then
		sed -i 's/-lwrap//g; s/-DTCP_WRAPPERS//g' Makefile
		echo '#undef TCP_WRAPPERS' >> config.h
	fi

	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"

	dodir /var/spool/qpage
	fowners daemon:daemon /var/spool/qpage
	fperms 770 /var/spool/qpage

	dodir /var/lock/subsys/qpage
	fowners daemon:daemon /var/lock/subsys/qpage
	fperms 770 /var/lock/subsys/qpage

	insinto /etc/qpage
	doins example.cf || die "doins example.cf failed"

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
