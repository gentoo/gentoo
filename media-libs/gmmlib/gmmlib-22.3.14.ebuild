# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"

inherit cmake-multilib

DESCRIPTION="Intel Graphics Memory Management Library"
HOMEPAGE="https://github.com/intel/gmmlib"
SRC_URI="https://github.com/intel/gmmlib/archive/intel-${P}.tar.gz"
S="${WORKDIR}/${PN}-intel-${P}"

KEYWORDS="amd64"
LICENSE="MIT"
SLOT="0/12.3"
IUSE="+custom-cflags test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-20.2.2_conditional_testing.patch
	"${FILESDIR}"/${PN}-20.3.2_cmake_project.patch
	"${FILESDIR}"/${PN}-22.1.1_custom_cflags.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING="$(usex test)"
		-DBUILD_TYPE="Release"
		-DOVERRIDE_COMPILER_FLAGS="$(usex !custom-cflags)"
	)

	cmake_src_configure
}
