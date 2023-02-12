# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Classic overhead run-and-gun game"
HOMEPAGE="https://cxong.github.io/cdogs-sdl/"
SRC_URI="https://github.com/cxong/cdogs-sdl/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ BSD-2 CC-BY-3.0 CC-BY-4.0 CC-BY-SA-3.0 CC0-1.0 WTFPL-2 XMAME"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl2[haptic,opengl]
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[mp3,vorbis,wav]
	net-libs/enet:1.3="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1-cmake.patch
)

src_configure() {
	# LTO warnings, bug #858527
	filter-lto

	local mycmakeargs=(
		-DCDOGS_DATA_DIR="${EPREFIX}"/usr/share/${PN}/
		-DBUILD_EDITOR=OFF
		-DUSE_SHARED_ENET=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc doc/{AUTHORS,original_readme.txt}

	# CREDITS is used at runtime, rest is licenses or duplicates
	find "${ED}"/usr/share/${PN}/doc -type f ! -name CREDITS -delete || die
}
