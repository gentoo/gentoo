# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

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
	KEYWORDS="~amd64"
fi

DESCRIPTION="Intel Media Driver for VAAPI (iHD)"
HOMEPAGE="https://github.com/intel/media-driver"

LICENSE="MIT BSD"
SLOT="0"
IUSE="+custom-cflags set-as-default test X"

RESTRICT="!test? ( test )"

DEPEND=">=media-libs/gmmlib-21.2.1
	>=x11-libs/libva-2.12.0[X?]
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-20.2.0_x11_optional.patch
	"${FILESDIR}"/${PN}-21.2.2_custom_cflags.patch
	"${FILESDIR}"/${PN}-20.4.5_testing_in_src_test.patch
)

src_configure() {
	local mycmakeargs=(
		-DMEDIA_BUILD_FATAL_WARNINGS=OFF
		-DMEDIA_RUN_TEST_SUITE=$(usex test)
		-DBUILD_TYPE=Release
		-DPLATFORM=linux
		-DUSE_X11=$(usex X)
		-DLATEST_CPP_NEEDED=ON # Seems to be the best option for now
		-DOVERRIDE_COMPILER_FLAGS=$(usex !custom-cflags)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use set-as-default ; then
		echo 'LIBVA_DRIVER_NAME="iHD"' > "${T}/55libva-intel-media-driver" || die
		doenvd "${T}/55libva-intel-media-driver"
	fi
}
