# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DXFRW_COMMIT="87ff1082f49b1286a033ac8f38fe8dde0975bb8b"
DXFRW_PV="0.6.3"
DXFRW_P="libdxfrw-${DXFRW_PV}-${DXFRW_COMMIT}"

inherit cmake-utils gnome2-utils

DESCRIPTION="Parametric 2d/3d CAD"
HOMEPAGE="http://solvespace.com"
SRC_URI="https://github.com/solvespace/solvespace/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/solvespace/libdxfrw/archive/${DXFRW_COMMIT}.tar.gz -> ${DXFRW_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-cpp/gtkmm:2.4=
	dev-cpp/pangomm:1.4
	dev-libs/json-c:=
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/glew:0=
	media-libs/libpng:0=
	virtual/opengl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

# NOTE: please keep commit hash actually when version up
GIT_COMMIT_HASH="4d1e1341d926ac356b295d5cc3d61c7a6cd7d07d"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3-gcc11-missing-limits-inc.patch
)

src_prepare() {
	rm -r "extlib/libdxfrw" || die  "rm extlib/libdxfrw failed"
	mv "${WORKDIR}/libdxfrw-${DXFRW_COMMIT}" "extlib/libdxfrw" || die "move libdxfrw-${DXFRW_COMMIT} failed"
	sed -i '/include(GetGitCommitHash)/d' CMakeLists.txt || die 'remove GetGitCommitHash by sed failed'
	# fixed in master already
	sed -i -e 's/CHAR_WIDTH/CHAR_WIDTH_/' src/textwin.cpp src/toolbar.cpp src/win32/w32main.cpp src/ui.h || die 'sed failed'
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGIT_COMMIT_HASH="${GIT_COMMIT_HASH}"
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
