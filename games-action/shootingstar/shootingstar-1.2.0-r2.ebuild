# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop toolchain-funcs

DESCRIPTION="A topdown shooter"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[opengl,sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-basic-fixes.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	newicon data/textures/body1.png ${PN}.png
	make_desktop_entry ${PN} "Shooting Star"
}
