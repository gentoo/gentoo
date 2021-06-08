# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="Viewer for PostScript and PDF documents using Ghostscript"
HOMEPAGE="https://www.gnu.org/software/gv/"
# Change 'gnu-alpha' to 'gnu' for final release, like 3.7.4
SRC_URI="https://alpha.gnu.org/gnu/gv/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="xinerama"

RDEPEND="
	app-text/ghostscript-gpl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXaw3d-1.6-r1[unicode]
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

src_configure() {
	export ac_cv_lib_Xinerama_main=$(usex xinerama)
	econf --enable-scrollbar-code
}

src_install() {
	rm README.{I18N,TRANSLATION} || die
	default

	doicon "${FILESDIR}"/gv_icon.xpm
	make_desktop_entry gv GhostView gv_icon 'Graphics;Viewer'
}
