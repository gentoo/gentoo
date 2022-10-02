# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A simple volleyball game"
HOMEPAGE="http://slime.tuxfamily.org/index.php"
SRC_URI="http://downloads.tuxfamily.org/slime/v${PV//.}/${PN}_${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	sys-devel/gettext
"
DEPEND="
	media-libs/libsdl[X,sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-net
	media-libs/sdl-ttf
	virtual/libintl
"
RDEPEND="${DEPEND}"

DOCS=( docs/{README,TODO} )

PATCHES=(
	"${FILESDIR}"/${P}-nodatalocal.patch
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-gcc10.patch
)

S="${WORKDIR}/${PN}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=TRUE
		-DDATA_DIR="${EPREFIX}/usr/share/slimevolley"
	)
	cmake_src_configure
}
