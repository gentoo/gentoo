# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN=libLASi
MY_P=${MY_PN}-${PV}

DESCRIPTION="C++ library for postscript stream output"
HOMEPAGE="http://www.unifont.org/lasi"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/2"
KEYWORDS="~alpha amd64 ~arm64 hppa ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	dev-libs/glib:2
	media-libs/freetype:2
	x11-libs/pango"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-pkgconfig.patch
)

src_prepare() {
	cmake_src_prepare
	sed -i \
		-e "s:\/lib$:\/$(get_libdir):" \
		-e "s/libLASi-\${VERSION}/${PF}/" \
		cmake/modules/instdirs.cmake || die
	sed -i \
		-e "s:\${DATA_DIR}/examples:/usr/share/doc/${PF}/examples:" \
		examples/CMakeLists.txt || die

	if use !examples; then
		sed -i -e '/add_subdirectory(examples)/d' CMakeLists.txt || die
	fi
}

src_configure() {
	# doesn't like CMAKE_BUILD_TYPE = Gentoo
	CMAKE_BUILD_TYPE=None
	local mycmakeargs=(
		-DDOXYGEN_EXECUTABLE=$(usex doc "${BROOT}"/usr/bin/doxygen '')
		-DUSE_RPATH=OFF
	)
	cmake_src_configure
}
