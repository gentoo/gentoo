# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake python-any-r1 xdg

DESCRIPTION="Classic overhead run-and-gun game"
HOMEPAGE="https://cxong.github.io/cdogs-sdl/"
SRC_URI="https://github.com/cxong/cdogs-sdl/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ BSD-2 CC0-1.0 CC-BY-3.0 CC-BY-SA-3.0 XMAME"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl2[haptic,opengl]
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[vorbis,wav]
	net-libs/enet:1.3="
DEPEND="${RDEPEND}"
BDEPEND="$(python_gen_any_dep 'dev-python/protobuf-python[${PYTHON_USEDEP}]')"

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
)

python_check_deps() {
	has_version -b "dev-python/protobuf-python[${PYTHON_USEDEP}]"
}

src_configure() {
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
