# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="XTide provides tide and current predictions in a wide variety of formats"
HOMEPAGE="https://flaterco.com/xtide/"
SRC_URI="https://flaterco.com/files/xtide/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-libs/libpng:=
	sci-geosciences/gpsd:=
	>=sci-geosciences/libtcd-2.2.5_p2:=
	x11-libs/libX11
	x11-libs/libXaw3dXft
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/libXt
	sys-libs/zlib"
RDEPEND="${DEPEND}
	media-fonts/font-schumacher-misc"

src_install() {
	default

	echo 'HFILE_PATH=/usr/share/harmonics' > 50xtide_harm || die
	doenvd 50xtide_harm

	newicon -s 48 iconsrc/icon_48x48_orig.png ${PN}.png
	make_desktop_entry ${PN} 'Tide prediction' ${PN} 'Science'

	find "${ED}" -name '*.la' -delete || die
}
