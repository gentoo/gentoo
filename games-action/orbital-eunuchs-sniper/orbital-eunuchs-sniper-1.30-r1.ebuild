# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

MY_P=${PN//-/_}-${PV}
DESCRIPTION="Snipe terrorists from your orbital base"
HOMEPAGE="http://icculus.org/oes/"
SRC_URI="http://filesingularity.timedoctor.org/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl[joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-datadir.patch
	"${FILESDIR}"/${P}-gcc43.patch
)
src_prepare() {
	default

	sed -i \
		-e '/^sleep /d' \
		configure.ac || die
	eautoreconf
}

src_install() {
	DOCS="AUTHORS ChangeLog readme.txt README TODO" \
		default
	make_desktop_entry snipe2d "Orbital Eunuchs Sniper"
}
