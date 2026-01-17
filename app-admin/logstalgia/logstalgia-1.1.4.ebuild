# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Replays or streams an access_log as a retro arcade game-like simulation"
HOMEPAGE="https://logstalgia.io/"
SRC_URI="https://github.com/acaudwell/Logstalgia/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/boost:=
	dev-libs/libpcre2:=
	media-libs/freetype:2
	media-libs/glew:0=
	media-libs/libglvnd
	media-libs/libsdl2[opengl,threads(+)]
	media-libs/libpng:0=
	media-libs/sdl2-image[jpeg,png]
	virtual/glu
"
DEPEND="${RDEPEND}
	media-libs/glm
"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-boost-1.89.patch" ) # bug 964296

src_prepare() {
	default
	eautoreconf
}

DOCS=( ChangeLog INSTALL README THANKS )
