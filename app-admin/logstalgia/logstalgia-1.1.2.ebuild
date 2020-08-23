# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Replays or streams an access_log as a retro arcade game-like simulation"
HOMEPAGE="https://logstalgia.io/"
SRC_URI="https://github.com/acaudwell/Logstalgia/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-libs/libpcre
	media-libs/freetype:2
	media-libs/glew:0=
	media-libs/libsdl2[opengl,threads]
	media-libs/libpng:0=
	media-libs/sdl2-image[jpeg,png]
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}
	dev-libs/boost
	media-libs/glm
	virtual/pkgconfig"

DOCS=( ChangeLog INSTALL README THANKS )
