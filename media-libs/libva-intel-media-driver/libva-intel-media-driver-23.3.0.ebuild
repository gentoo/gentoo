# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

if [[ ${PV} == *9999 ]] ; then
	: ${EGIT_REPO_URI:="https://github.com/intel/media-driver"}
	if [[ ${PV%9999} != "" ]] ; then
		: ${EGIT_BRANCH:="release/${PV%.9999}"}
	fi
	inherit git-r3
else
	MY_PV="${PV%_pre}"
	SRC_URI="https://github.com/intel/media-driver/archive/intel-media-${MY_PV}.tar.gz"
	S="${WORKDIR}/media-driver-intel-media-${MY_PV}"
	if [[ ${PV} != *_pre* ]] ; then
		KEYWORDS="~amd64"
	fi
fi

DESCRIPTION="Intel Media Driver for VA-API (iHD)"
HOMEPAGE="https://github.com/intel/media-driver"

LICENSE="MIT BSD redistributable? ( no-source-code )"
SLOT="0"
IUSE="+redistributable test X"

RESTRICT="!test? ( test )"

DEPEND=">=media-libs/gmmlib-22.3.9:=[${MULTILIB_USEDEP}]
	>=media-libs/libva-2.19.0[X?,${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-21.4.2-Remove-unwanted-CFLAGS.patch
	"${FILESDIR}"/${PN}-20.4.5_testing_in_src_test.patch
)

multilib_src_configure() {
	# https://github.com/intel/media-driver/issues/356
	append-cxxflags -D_FILE_OFFSET_BITS=64

	local mycmakeargs=(
		-DMEDIA_BUILD_FATAL_WARNINGS=OFF
		-DMEDIA_RUN_TEST_SUITE=$(usex test)
		-DBUILD_TYPE=Release
		-DPLATFORM=linux
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=$(usex !X)
		-DENABLE_NONFREE_KERNELS=$(usex redistributable)
		-DLATEST_CPP_NEEDED=ON # Seems to be the best option for now
	)
	local CMAKE_BUILD_TYPE="Release"
	cmake_src_configure
}
