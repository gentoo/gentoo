# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils xdg-utils

DESCRIPTION="A fast text editor supporting folding, syntax highlighting, etc."
HOMEPAGE="https://github.com/lanurmi/efte"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="|| ( GPL-2 Artistic )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gpm X"

RDEPEND="sys-libs/ncurses:0=
	gpm? ( sys-libs/gpm )
	X? (
		x11-libs/libX11
		x11-libs/libXpm
		x11-libs/libXdmcp
		x11-libs/libXau
		media-fonts/font-misc-misc
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-desktopfile.patch
)

src_configure() {
	local mycmakeargs=(
		-DUSE_GPM=$(usex gpm)
		-DBUILD_X=$(usex X )
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	rm -f "${D}"/usr/share/doc/${PN}/{COPYING,Artistic}
	mv "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${PF}" || die
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
