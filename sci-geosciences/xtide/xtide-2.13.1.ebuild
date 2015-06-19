# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/xtide/xtide-2.13.1.ebuild,v 1.1 2013/07/13 11:29:18 hasufell Exp $

EAPI=5

inherit autotools eutils gnome2-utils

DESCRIPTION="XTide provides tide and current predictions in a wide variety of formats"
HOMEPAGE="http://www.flaterco.com/xtide/"
SRC_URI="ftp://ftp.flaterco.com/xtide/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gps"

DEPEND="
	media-libs/libpng:0
	>=sci-geosciences/libtcd-2.2.5_p2
	x11-libs/libX11
	x11-libs/libXaw3d
	x11-libs/libXpm
	x11-libs/libXt
	gps? ( sci-geosciences/gpsd )"
RDEPEND="${DEPEND}
	media-fonts/font-schumacher-misc"
DEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-{Werror,gps-switch}.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_with gps)
}

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
