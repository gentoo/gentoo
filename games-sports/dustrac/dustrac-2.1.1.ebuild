# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-fonts/ubuntu-font-family
	media-libs/libvorbis
	media-libs/openal
	virtual/opengl
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=(
	# upstream backports
	"${FILESDIR}"/${P}-cmake_policy_0100.patch
	# downstream patches
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-cmake-add_library-static.patch
	"${FILESDIR}"/${P}-cmake4.patch
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
