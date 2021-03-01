# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake

inherit cmake-multilib

if [[ ${PV} == *9999 ]] ; then
	: ${EGIT_REPO_URI:="https://github.com/intel/gmmlib"}
	if [[ ${PV%9999} != "" ]] ; then
		: ${EGIT_BRANCH:="release/${PV%.9999}"}
	fi
	inherit git-r3
fi

DESCRIPTION="Intel Graphics Memory Management Library"
HOMEPAGE="https://github.com/intel/gmmlib"
if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
else
	SRC_URI="https://github.com/intel/gmmlib/archive/intel-${P}.tar.gz"
	S="${WORKDIR}/${PN}-intel-${P}"
	KEYWORDS="amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test +custom-cflags"

RESTRICT="!test? ( test )"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-20.2.2_conditional_testing.patch
	"${FILESDIR}"/${PN}-20.4.1_custom_cflags.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TYPE=Release
		-DBUILD_TESTING=$(usex test)
		-DOVERRIDE_COMPILER_FLAGS=$(usex !custom-cflags)
	)
	cmake_src_configure
}
