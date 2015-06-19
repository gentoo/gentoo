# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/skippy/skippy-0.5.0.ebuild,v 1.15 2012/05/05 04:53:46 jdhore Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="A full-screen task-switcher providing Apple Expose-like functionality with various WMs"
HOMEPAGE="http://thegraveyard.org/skippy.php"
SRC_URI="http://thegraveyard.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="media-libs/imlib2[X]
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXmu
	x11-libs/libXft"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xineramaproto
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-pointer-size.patch \
		"${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc CHANGELOG skippyrc-default
}

pkg_postinst() {
	echo
	elog "You should copy skippyrc-default from /usr/share/doc/${PF} to"
	elog "~/.skippyrc and edit the keysym used to invoke skippy."
	elog "Use x11-apps/xev to find out the keysym."
	echo
}
