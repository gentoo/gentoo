# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Intel Graphics Memory Management Library"
HOMEPAGE="https://github.com/intel/gmmlib"
SRC_URI="https://github.com/intel/gmmlib/archive/intel-${P}.tar.gz"
S="${WORKDIR}/${PN}-intel-${P}"

KEYWORDS="amd64"
LICENSE="MIT"
# gmmlib version 22.0.3 made breaking ABI changes without changing the
# soname, so the "_1" subslot suffix was added. There is no need to keep
# this suffix after the next soname version bump.
SLOT="0/12_1"
IUSE="+custom-cflags test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-20.2.2_conditional_testing.patch
	"${FILESDIR}"/${PN}-20.4.1_custom_cflags.patch
	"${FILESDIR}"/${PN}-20.3.2_cmake_project.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING="$(usex test)"
		-DBUILD_TYPE="Release"
		-DOVERRIDE_COMPILER_FLAGS="$(usex !custom-cflags)"
	)

	cmake_src_configure
}
