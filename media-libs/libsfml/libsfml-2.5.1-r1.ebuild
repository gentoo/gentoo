# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="https://www.sfml-dev.org/ https://github.com/SFML/SFML"
SRC_URI="https://github.com/SFML/SFML/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
IUSE="debug doc examples"

RDEPEND="
	media-libs/flac:=
	media-libs/freetype:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libogg
	media-libs/libvorbis
	media-libs/openal
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/xcb-util-image
	kernel_linux? ( virtual/libudev:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-text/doxygen )
"

DOCS=( changelog.md readme.md )

S="${WORKDIR}/SFML-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-musl-1.2.3-nullptr.patch
)

src_prepare() {
	sed -i "s:DESTINATION .*:DESTINATION /usr/share/doc/${PF}:" \
		doc/CMakeLists.txt || die

	find examples -name CMakeLists.txt -delete || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSFML_BUILD_DOC=$(usex doc)
		-DSFML_INSTALL_PKGCONFIG_FILES=TRUE
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/share/cmake/Modules
	doins cmake/SFMLConfig.cmake.in
	doins cmake/SFMLConfigDependencies.cmake.in

	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
