# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=5cb589a5b82c13ba8f0542e5e79629da7645cb3c
inherit cmake-multilib flag-o-matic

DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="https://taglib.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MPL-1.1"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~mips ~ppc ~ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
SLOT="0"
IUSE="debug examples test"

RDEPEND=">=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	test? ( >=dev-util/cppunit-1.13.2[${MULTILIB_USEDEP}] )
"

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.11-install-examples.patch
	"${FILESDIR}"/${P}-version-1.11.2.patch
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/taglib-config
)

src_prepare() {
	cmake-utils_src_prepare

	sed -e "s/BUILD_TESTS AND NOT BUILD_SHARED_LIBS/BUILD_TESTS/" \
		-i CMakeLists.txt \
		-i ConfigureChecks.cmake || die

	# bug 651744
	append-cxxflags -std=c++11
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(multilib_native_usex examples)
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTS=$(usex test)
	)

	cmake-utils_src_configure
}

multilib_src_test() {
	# ctest does not work
	emake -C "${BUILD_DIR}" check
}
