# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
COMMIT=54508df30bc888c4d2359576ceb0cc8f2fa8dbdf
inherit cmake-multilib

DESCRIPTION="Library for reading and editing audio meta data"
HOMEPAGE="https://taglib.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MPL-1.1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
SLOT="0"
IUSE="debug examples test"
RESTRICT="!test? ( test )"

BDEPEND=">=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"
RDEPEND=">=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cppunit-1.13.2[${MULTILIB_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.11-install-examples.patch
	"${FILESDIR}"/${PN}-1.11.1_p20181028-version-1.11.2.patch
	"${FILESDIR}"/${PN}-1.11.1_p20181028-libdir.patch
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/taglib-config
)

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	cmake_src_prepare

	sed -e "s/BUILD_TESTS AND NOT BUILD_SHARED_LIBS/BUILD_TESTS/" \
		-i CMakeLists.txt \
		-i ConfigureChecks.cmake || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(multilib_native_usex examples)
		-DBUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
