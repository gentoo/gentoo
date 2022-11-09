# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="A menu-driven tool to draw and manipulate objects interactively in an X window"
HOMEPAGE="http://mcj.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/mcj/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="jpeg nls postscript"

RDEPEND="
	x11-libs/libXaw
	x11-libs/libXaw3d
	x11-libs/libXi
	x11-libs/libXt
	media-libs/libpng:0=
	media-fonts/font-misc-misc
	media-fonts/urw-fonts
	>=media-gfx/transfig-3.2.5-r1
	media-libs/netpbm
	jpeg? ( media-libs/libjpeg-turbo:= )
	nls? ( x11-libs/libXaw3d[unicode(+)] )
	postscript? ( app-text/ghostscript-gpl )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}/${PN}-3.2.6a-urwfonts.patch"
	"${FILESDIR}/${PN}-3.2.6a-solaris.patch"
	"${FILESDIR}/${PN}-3.2.6a-app-defaults.patch"
	"${FILESDIR}/${PN}-3.2.7b-ghostscript.patch"
)

src_configure() {
	local myeconfargs=(
		$(use_enable nls i18n)
		$(use_enable jpeg)
		$(use_with postscript gs)
		--htmldir="${EPREFIX}/usr/share/doc/${PF}" # it expects docdir...
	)
	econf "${myeconfargs[@]}"
}
