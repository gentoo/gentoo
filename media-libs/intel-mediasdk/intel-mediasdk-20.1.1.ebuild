# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake
if [[ ${PV} == *9999 ]] ; then
	: ${EGIT_REPO_URI:="https://github.com/Intel-Media-SDK/MediaSDK"}
	if [[ ${PV%9999} != "" ]] ; then
		: ${EGIT_BRANCH:="release/${PV%.9999}"}
	fi
	inherit git-r3
fi

DESCRIPTION="Intel Media SDK"
HOMEPAGE="http://mediasdk.intel.com"
if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/Intel-Media-SDK/MediaSDK/archive/intel-mediasdk-${PV}.tar.gz"
	S="${WORKDIR}/media-driver-intel-media-${PV}"
	KEYWORDS="-* ~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="opencl wayland +dri3 tools"

S="${WORKDIR}/MediaSDK-${P}"

DEPEND="
	>=x11-libs/libva-intel-media-driver-${PV}
	>=media-video/libva-utils-2.7.1
	opencl? (	virtual/opencl
				dev-util/opencl-headers
				dev-libs/clhpp	)
	wayland? ( dev-libs/wayland )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$( usex opencl "-DENABLE_OPENCL=ON" "-DENABLE_OPENCL=OFF" )
		$( usex dri3 "-DENABLE_X11_DRI3=ON" "-DENABLE_X11_DRI3=OFF")
		$( usex wayland "-DENABLE_WAYLAND=ON" "-DENABLE_WAYLAND=OFF" )
		)
	cmake-utils_src_configure
}
