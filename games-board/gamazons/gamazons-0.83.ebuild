# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit gnome2

DESCRIPTION="A chess/go hybrid"
HOMEPAGE="http://www.yorgalily.org/gamazons/"
SRC_URI="http://www.yorgalily.org/${PN}/src/$P.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=">=gnome-base/libgnomeui-2"
RDEPEND=${DEPEND}

src_prepare() {
	gnome2_src_prepare
	sed -i \
		-e '/^Encoding/d' \
		-e '/Categories/s/GNOME;Application;//' \
		-e '/Icon/s/\.png//' \
		pixmaps/gamazons.desktop \
		|| die
}
