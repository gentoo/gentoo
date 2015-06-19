# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mpgtx/mpgtx-1.3.1-r2.ebuild,v 1.4 2015/03/28 21:35:37 ago Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Command line MPEG audio/video/system file toolbox"
SRC_URI="mirror://sourceforge/mpgtx/${P}.tar.gz"
HOMEPAGE="http://mpgtx.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-configure.patch \
		"${FILESDIR}"/${P}-dont-ignore-cxx-flags.patch
	tc-export CXX
}

src_configure() {
	./configure --parachute || die
}

src_install() {
	dobin mpgtx

	dosym mpgtx /usr/bin/mpgjoin
	dosym mpgtx /usr/bin/mpgsplit
	dosym mpgtx /usr/bin/mpgcat
	dosym mpgtx /usr/bin/mpginfo
	dosym mpgtx /usr/bin/mpgdemux
	dosym mpgtx /usr/bin/tagmp3

	doman man/mpgtx.1 man/tagmp3.1

	dosym /usr/share/man/man1/mpgtx.1 /usr/share/man/man1/mpgcat.1
	dosym /usr/share/man/man1/mpgtx.1 /usr/share/man/man1/mpgjoin.1
	dosym /usr/share/man/man1/mpgtx.1 /usr/share/man/man1/mpginfo.1
	dosym /usr/share/man/man1/mpgtx.1 /usr/share/man/man1/mpgsplit.1
	dosym /usr/share/man/man1/mpgtx.1 /usr/share/man/man1/mpgdemux.1

	dodoc AUTHORS ChangeLog README TODO
}
