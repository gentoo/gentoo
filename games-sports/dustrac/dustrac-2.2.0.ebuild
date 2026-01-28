# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=73617c081e42a1d4b9044ac1545522ba5cd667a9
inherit cmake xdg

DESCRIPTION="Tile-based, cross-platform 2D racing game"
HOMEPAGE="https://juzzlin.github.io/DustRacing2D/"
SRC_URI="https://github.com/juzzlin/DustRacing2D/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/DustRacing2D-${PV}"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtbase:6[gui,opengl,sql,widgets,xml]
	media-fonts/ubuntu-font-family
	media-libs/libvorbis
	media-libs/openal
	virtual/opengl
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.1_p20250924-cmake.patch # downstream patch
	"${FILESDIR}"/${P}-missing-header.patch # in git master
)

src_configure() {
	# -DGLES=ON didn't build for me but maybe just need use flags on some Qt package?
	# Maybe add a local gles use flag
	local mycmakeargs=(
		-DReleaseBuild=ON
		-DSystemFonts=ON
		-DOpenGL_GL_PREFERENCE=GLVND
		-DDATA_PATH=/usr/share/${PN}
		-DBIN_PATH=/usr/bin
		-DDOC_PATH=/usr/share/doc/${PF}
		-DBUILD_TESTING=$(usex test)
		-DUSE_CCACHE=OFF
	)
	cmake_src_configure
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	cmake_src_test
}

src_install() {
	cmake_src_install

	dosym ../../fonts/ubuntu-font-family/UbuntuMono-B.ttf /usr/share/${PN}/fonts/UbuntuMono-B.ttf
	dosym ../../fonts/ubuntu-font-family/UbuntuMono-R.ttf /usr/share/${PN}/fonts/UbuntuMono-R.ttf
}
