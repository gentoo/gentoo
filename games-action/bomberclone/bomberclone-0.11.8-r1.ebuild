# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils autotools

DESCRIPTION="BomberMan clone with network game support"
HOMEPAGE="http://www.bomberclone.de/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~x86"
IUSE="X"

DEPEND=">=media-libs/libsdl-1.1.0[video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]
	X? ( x11-libs/libXt )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc52.patch
	"${FILESDIR}"/${P}-underlink.patch
)

src_prepare() {
	default

	ecvs_clean
	mv configure.{in,ac} || die
	sed -i -e 's/configure.in/configure.ac/' configure.ac || die
	sed -i \
		-e "s:/share/games/:share/:" \
		configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_with X x) \
		--datadir=/usr/share
	sed -i \
		-e "/PACKAGE_DATA_DIR/ s:/usr/games/share/games/:/usr/share:" \
		config.h || die
}

src_install() {
	default

	dobin src/${PN}

	insinto /usr/share/${PN}
	doins -r data/{gfx,maps,player,tileset,music}
	find "${D}" -name "Makefile*" -exec rm -f '{}' +

	doicon data/pixmaps/bomberclone.png
	make_desktop_entry bomberclone Bomberclone
}
