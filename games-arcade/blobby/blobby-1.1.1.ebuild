# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{3,4} )

inherit cmake edo flag-o-matic lua-single xdg

DESCRIPTION="Beach ball game with blobs of goo"
HOMEPAGE="https://sourceforge.net/projects/blobby/"
SRC_URI="https://downloads.sourceforge.net/project/blobby/Blobby%20Volley%202%20%28Linux%29/${PV}/${PN}2-linux-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${LUA_DEPS}
	dev-games/physfs[zip]
	dev-libs/tinyxml2:=
	media-libs/libglvnd
	media-libs/libsdl2[sound,joystick,opengl,video]
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1-fix_linkedlist.patch # from upstream
	"${FILESDIR}"/${PN}-1.1.1-fix_deps.patch
)

src_prepare() {
	cmake_src_prepare
	# lua and tinyxml2 unbundled by patch
	cmake_comment_add_subdirectory deps
}

src_configure() {
	# https://github.com/danielknobe/blobbyvolley2/issues/163
	filter-lto
	append-flags -fno-strict-aliasing
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	pushd "${BUILD_DIR}"/test || die
	edo ./blobbytest --report_level=short
	popd || die
}
