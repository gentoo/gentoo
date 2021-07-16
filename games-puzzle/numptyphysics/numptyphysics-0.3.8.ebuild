# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs xdg

DESCRIPTION="Crayon Physics-like drawing puzzle game using the same excellent Box2D engine"
HOMEPAGE="https://github.com/thp/numptyphysics"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/thp/numptyphysics.git"
else
	SRC_URI="https://github.com/thp/numptyphysics/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD GPL-3+ ZLIB"
SLOT="0"

RDEPEND="
	dev-libs/glib:2
	media-libs/libsdl2[opengl,video]
	media-libs/sdl2-image[png]
	media-libs/sdl2-ttf
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-empty-tr.patch
	"${FILESDIR}"/${P}-respect-flags.patch
)

src_compile() {
	tc-export AR CC CXX PKG_CONFIG RANLIB

	emake V=1
}
