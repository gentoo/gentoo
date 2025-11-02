# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake virtualx

DESCRIPTION="Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="https://www.sfml-dev.org/ https://github.com/SFML/SFML"
SRC_URI="https://github.com/SFML/SFML/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/SFML-${PV}"

LICENSE="ZLIB"
# Vendored header dependencies:
# glad
LICENSE+=" Apache-2.0 || ( WTFPL-2 CC0-1.0 )"
# miniaudio
LICENSE+=" || ( MIT-0 public-domain )"
# minimp3
LICENSE+=" CC0-1.0"
# stb_image
LICENSE+=" || ( MIT public-domain )"
# vulkan
LICENSE+=" Apache-2.0"

SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/flac:=
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libvorbis
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/xcb-util-image
	kernel_linux? ( virtual/libudev:= )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	doc? ( app-text/doxygen )
	test? ( >=dev-cpp/catch-3.7.0 )
"

DOCS=( changelog.md readme.md )

PATCHES=(
	"${FILESDIR}"/libsfml-3.0.0-catch-depend.patch
)

src_configure() {
	local mycmakeargs=(
		-DSFML_BUILD_DOC=$(usex doc)
		-DSFML_USE_SYSTEM_DEPS=ON
		-DSFML_INSTALL_PKGCONFIG_FILES=ON
		-DSFML_PKGCONFIG_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)/pkgconfig/"
		-DSFML_BUILD_TEST_SUITE=$(usex test)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build doc
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# Requires a more capable graphical enviroment (opengl?)
		"sf::Window"
		# Requires a running pulseaudio daemon to query
		"sf::Sound"
		"sf::SoundStream"
		# Network sandbox
		"sf::IpAddress"
	)
	virtx cmake_src_test
}

src_install() {
	cmake_src_install

	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
