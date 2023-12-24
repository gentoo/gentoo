# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature xdg

DESCRIPTION="A menu-driven tool to draw and manipulate objects interactively in an X window"
HOMEPAGE="https://mcj.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/mcj/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

COMMON_DEPEND="
	app-text/ghostscript-gpl:=
	>=media-gfx/fig2dev-${PV}
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/tiff:=
	x11-libs/libX11
	x11-libs/libXaw3d[unicode(+)]
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/libXt
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	media-fonts/font-misc-misc
	media-fonts/urw-fonts
"

PATCHES=(
	"${FILESDIR}/${PN}-3.2.6a-solaris.patch"
	"${FILESDIR}/${PN}-3.2.9-app-defaults.patch"
)

src_configure() {
	local myeconfargs=(
		--htmldir="${EPREFIX}/usr/share/doc/${PF}" # it expects docdir...
	)
	econf "${myeconfargs[@]}"
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "GIF support" media-libs/netpbm virtual/imagemagick-tools
}
