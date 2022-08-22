# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop gnome2-utils

DESCRIPTION="XTide provides tide and current predictions in a wide variety of formats"
HOMEPAGE="https://flaterco.com/xtide/"
SRC_URI="ftp://ftp.flaterco.com/xtide/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	media-libs/libpng:0=
	sci-geosciences/gpsd
	>=sci-geosciences/libtcd-2.2.5_p2
	x11-libs/libX11
	x11-libs/libXaw3d[unicode]
	x11-libs/libXaw3dXft
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/libXt
"
RDEPEND="${DEPEND}
	media-fonts/font-schumacher-misc
"

src_install() {
	default

	echo 'HFILE_PATH=/usr/share/harmonics' > 50xtide_harm
	doenvd 50xtide_harm

	newicon -s 48 iconsrc/icon_48x48_orig.png ${PN}.png
	make_desktop_entry ${PN} 'Tide prediction' ${PN} 'Science'
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
