# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop xdg-utils

DESCRIPTION="Fast-paced 3D lightcycle game based on Tron"
HOMEPAGE="http://armagetronad.org/"
SRC_URI="https://launchpad.net/armagetronad/$(ver_cut 1-3)/${PV}/+download/armagetronad-${PV}.tbz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated sound"

RDEPEND="
	dev-libs/libxml2
	!dedicated? (
		media-libs/libpng:0=
		media-libs/libsdl[X,opengl,video,sound?]
		media-libs/sdl-image[jpeg,png]
		virtual/glu
		virtual/opengl
		sound? ( media-libs/sdl-mixer )
	)"
DEPEND=${RDEPEND}

PATCHES=("${FILESDIR}"/${P}-AR.patch)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# --enable-games just messes up paths
	econf \
		$(use_enable dedicated) \
		$(use_enable sound music) \
		--disable-sysinstall \
		--disable-useradd \
		--disable-uninstall \
		--disable-games
}

src_install() {
	default

	# misplaced desktop-file/icons
	rm -r "${ED}"/usr/share/${PN}/desktop || die
	doicon -s 48 desktop/icons/48x48/armagetronad.png
	make_desktop_entry ${PN}
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
