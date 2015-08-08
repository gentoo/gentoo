# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils

DESCRIPTION="XTide provides tide and current predictions in a wide variety of formats"
HOMEPAGE="http://www.flaterco.com/xtide/"
SRC_URI="ftp://ftp.flaterco.com/xtide/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-fonts/font-schumacher-misc
	media-libs/libpng:0
	>=sci-geosciences/libtcd-2.2.5_p2
	x11-libs/libX11
	>=x11-libs/libXaw-1.0.3
	>=x11-libs/libXpm-3.5.6
	x11-libs/libXt"
RDEPEND="${DEPEND}"

src_install() {
	dobin xtide tide xttpd
	doman *.[18]

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
