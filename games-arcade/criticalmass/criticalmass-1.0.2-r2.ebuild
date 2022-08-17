# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic

MY_P="CriticalMass-${PV}"

DESCRIPTION="SDL/OpenGL space shoot'em up game"
HOMEPAGE="http://criticalmass.sourceforge.net/"
SRC_URI="mirror://sourceforge/criticalmass/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+ ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libglvnd[X]
	media-libs/libpng:=
	media-libs/libsdl[opengl,sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]
	net-misc/curl
	sys-libs/zlib:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-system-curl.patch
	"${FILESDIR}"/${P}-libpng.patch
	"${FILESDIR}"/${P}-flags.patch
)

src_prepare() {
	default

	rm -r curl || die
	eautoreconf

	append-cxxflags -std=gnu++98 #612758
}

src_install() {
	local HTML_DOCS="Readme.html"
	default

	rm "${ED}"/usr/bin/Packer || die #247449

	newicon critter.png ${PN}.png
	make_desktop_entry critter "Critical Mass"
}
