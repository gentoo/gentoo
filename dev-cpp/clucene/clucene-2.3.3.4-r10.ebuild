# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN}"-core
MY_P="${MY_PN}"-"${PV}"
inherit cmake

DESCRIPTION="High-performance, full-featured text search engine based off of lucene in C++"
HOMEPAGE="https://clucene.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/clucene/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="|| ( Apache-2.0 LGPL-2.1 )"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug doc static-libs"
RESTRICT="test"

BDEPEND="doc? ( >=app-text/doxygen-1.4.2 )"

DOCS=(AUTHORS ChangeLog README README.PACKAGE REQUESTS)

PATCHES=(
	"${FILESDIR}/${P}-fix-clang.patch"
	"${FILESDIR}/${P}-contrib.patch"
	"${FILESDIR}/${P}-pkgconfig.patch"
	"${FILESDIR}/${P}-gcc6.patch"
	"${FILESDIR}/${P}-gmtime.patch"
	"${FILESDIR}/${P}-musl-pthread.patch"
	"${FILESDIR}/${P}-libcxx.patch"
	"${FILESDIR}/${P}-fix-binary-function.patch"
)

src_prepare() {
	cmake_src_prepare

	# patch out installing bundled boost headers, we build against system one
	sed -i \
		-e '/ADD_SUBDIRECTORY (src\/ext)/d' \
		CMakeLists.txt || die
	sed -i \
		-e 's%\(:\| -I\)${prefix}/include/CLucene/ext%%g' \
		./src/core/libclucene-core.pc.cmake || die
	rm -rf src/ext || die
}

src_configure() {
	# Disabled threads: see upstream bug
	# https://sourceforge.net/p/clucene/bugs/197/
	local mycmakeargs=(
		-DENABLE_ASCII_MODE=OFF
		-DENABLE_PACKAGING=OFF
		-DDISABLE_MULTITHREADING=OFF
		-DBUILD_CONTRIBS_LIB=ON
		-DLIB_DESTINATION="${EPREFIX}/usr/$(get_libdir)"
		-DENABLE_DEBUG=$(usex debug)
		-DENABLE_CLDOCS=$(usex doc)
		-DBUILD_STATIC_LIBRARIES=$(usex static-libs)
	)

	cmake_src_configure
}
