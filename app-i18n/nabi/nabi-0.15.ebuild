# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/nabi/nabi-0.15.ebuild,v 1.11 2013/03/10 06:29:11 naota Exp $

EAPI="4"

inherit eutils autotools

DESCRIPTION="Simple Hanguk X Input Method"
HOMEPAGE="https://code.google.com/p/nabi/"
SRC_URI="http://download.kldp.net/nabi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ppc x86"

RDEPEND=">=x11-libs/gtk+-2.2:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.15-asneeded.patch
	eautoreconf
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog README NEWS
}

pkg_postinst() {
	elog "You MUST add environment variable..."
	elog
	elog "export XMODIFIERS=\"@im=nabi\""
	elog
}
