# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

DESCRIPTION="Library of cd audio related routines"
HOMEPAGE="http://libcdaudio.sourceforge.net/"
SRC_URI="mirror://sourceforge/libcdaudio/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.99-CAN-2005-0706.patch #84936
	epatch "${FILESDIR}"/${P}-bug245649.patch
}

src_compile() {
	econf --enable-threads
	emake || die "compile problem."
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
