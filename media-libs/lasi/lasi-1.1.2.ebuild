# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib

MY_PN=libLASi
MY_P=${MY_PN}-${PV}

DESCRIPTION="C++ library for postscript stream output"
HOMEPAGE="http://www.unifont.org/lasi/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	dev-libs/glib:2
	media-libs/freetype:2
	x11-libs/pango"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-cmake.patch
	"${FILESDIR}"/${PN}-1.1.0-pkgconfig.patch
)

src_prepare() {
	cmake-utils_src_prepare
	sed -i \
		-e "s:\/lib$:\/$(get_libdir):" \
		-e "s/libLASi-\${VERSION}/${PF}/" \
		cmake/modules/instdirs.cmake \
		|| die "Failed to fix cmake module"
	sed -i \
		-e "s:\${DATA_DIR}/examples:/usr/share/doc/${PF}/examples:" \
		examples/CMakeLists.txt || die

	use examples || sed -i -e '/add_subdirectory(examples)/d' CMakeLists.txt
}

src_configure() {
	CMAKE_BUILD_TYPE=None
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/$(get_libdir)
	)
	use doc || mycmakeargs+=( -DDOXYGEN_EXECUTABLE= )
	cmake-utils_src_configure
}
