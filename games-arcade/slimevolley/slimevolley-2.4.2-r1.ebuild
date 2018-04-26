# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="A simple volleyball game"
HOMEPAGE="http://slime.tuxfamily.org/index.php"
SRC_URI="http://downloads.tuxfamily.org/slime/v242/${PN}_${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="net"

RDEPEND="
	media-libs/libsdl[X,sound,video]
	media-libs/sdl-ttf
	media-libs/sdl-image[png]
	net? ( media-libs/sdl-net )
	virtual/libintl
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

DOCS="docs/README docs/TODO"

PATCHES=(
	"${FILESDIR}"/${P}-nodatalocal.patch
	"${FILESDIR}"/${P}-underlink.patch
)

S="${WORKDIR}/${PN}"

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_VERBOSE_MAKEFILE=TRUE"
		"-DCMAKE_INSTALL_PREFIX=/usr"
		"-DDATA_DIR=/usr/share/slimevolley"
		$(use net && echo "-DNO_NET=0" || echo "-DNO_NET=1")
	)
	cmake-utils_src_configure
}
