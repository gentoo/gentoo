# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils virtualx

DESCRIPTION="Tile-based, cross-platform 2D racing game"
HOMEPAGE="https://juzzlin.github.io/DustRacing2D/"
SRC_URI="https://github.com/juzzlin/DustRacing2D/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/DustRacing2D-${PV}"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
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
	"${FILESDIR}"/${P}-gcc10.patch # bug 722524
	"${FILESDIR}"/${P}-opengl.patch
	"${FILESDIR}"/${P}-appdata.patch
	# downstream patches
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-cmake-add_library-static.patch
)

src_configure() {
	# -DGLES=ON didn't build for me but maybe just need use flags on some Qt package?
	# Maybe add a local gles use flag
	local mycmakeargs=(
		-DReleaseBuild=ON
		-DOpenGL_GL_PREFERENCE=GLVND
		-DDATA_PATH=/usr/share/${PN}
		-DBIN_PATH=/usr/bin
		-DDOC_PATH=/usr/share/doc/${PF}
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}

src_install() {
	cmake_src_install

	dosym ../../fonts/ubuntu-font-family/UbuntuMono-B.ttf /usr/share/${PN}/fonts/UbuntuMono-B.ttf
	dosym ../../fonts/ubuntu-font-family/UbuntuMono-R.ttf /usr/share/${PN}/fonts/UbuntuMono-R.ttf
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
