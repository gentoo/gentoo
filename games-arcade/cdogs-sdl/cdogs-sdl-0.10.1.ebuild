# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Classic overhead run-and-gun game"
HOMEPAGE="https://cxong.github.io/cdogs-sdl/"
SRC_URI="https://github.com/cxong/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ BSD-2 CC0-1.0 CC-BY-3.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/protobuf-python
	media-libs/libsdl2[haptic,opengl]
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[vorbis,wav]
	net-libs/enet:1.3="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-Add-BUILD_EDITOR-option.patch"
	"${FILESDIR}/${P}-Remove-Winline-and-Werror-definitions.patch"
)

src_prepare() {
	rm -f doc/{COPYING.,LICENSE.,license.,README_DATA.md}* || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCDOGS_DATA_DIR="${EPREFIX}/usr/share/${PN}/"
		-DCDOGS_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}/"
		-DBUILD_EDITOR=OFF
		-DUSE_SHARED_ENET=ON
	)
	cmake_src_configure
}
