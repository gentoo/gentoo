# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="A full-screen task-switcher providing Apple Expose-like functionality"
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

PATCHES=( "${FILESDIR}"/${PN}-pointer-size.patch
	"${FILESDIR}"/${P}-Makefile.patch
)

DOCS=( CHANGELOG skippyrc-default )

src_compile() {
	tc-export CC
	default
}

pkg_postinst() {
	elog
	elog "You should copy skippyrc-default from /usr/share/doc/${PF} to"
	elog "~/.skippyrc and edit the keysym used to invoke skippy."
	elog "Use x11-apps/xev to find out the keysym."
	elog
}
