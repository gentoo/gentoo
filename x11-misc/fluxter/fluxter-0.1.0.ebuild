# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="workspace pager dockapp, particularly useful with the Fluxbox window manager"
HOMEPAGE="http://www.isomedia.com/homes/stevencooper"
SRC_URI="http://www.isomedia.com/homes/stevencooper/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libSM
	x11-libs/libICE"

PATCHES=( "${FILESDIR}/${P}-asneeded.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--datadir="${EPREFIX}"/usr/share/commonbox
}
