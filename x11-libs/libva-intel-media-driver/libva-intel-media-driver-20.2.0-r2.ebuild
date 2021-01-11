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
	SRC_URI="https://github.com/intel/media-driver/archive/intel-media-${PV}.tar.gz"
	S="${WORKDIR}/media-driver-intel-media-${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Intel Media Driver for VAAPI (iHD)"
HOMEPAGE="https://github.com/intel/media-driver"

LICENSE="MIT BSD"
SLOT="0"
IUSE="X set-as-default"

PATCHES=( "${FILESDIR}"/${PN}-20.2.0_x11_optional.patch )

DEPEND=">=media-libs/gmmlib-20.2.2
	>=x11-libs/libva-2.8.0[X?]
	>=x11-libs/libpciaccess-0.13.1-r1:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DMEDIA_BUILD_FATAL_WARNINGS=OFF
		-DMEDIA_RUN_TEST_SUITE=OFF
		-DBUILD_TYPE=release
		-DPLATFORM=linux
		-DUSE_X11=$(usex X)
		-DINSTALL_DRIVER_SYSCONF=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use 'set-as-default' ; then
		echo 'LIBVA_DRIVER_NAME="iHD"' > "${T}/55libva-intel-media-driver" || die
		doenvd "${T}/55libva-intel-media-driver"
	fi
}
