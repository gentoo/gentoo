# Copyright 1999-2021 Gentoo Authors
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
else
	SRC_URI="https://github.com/Intel-Media-SDK/MediaSDK/archive/intel-mediasdk-${PV}.tar.gz"
	S="${WORKDIR}/MediaSDK-intel-mediasdk-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	>=x11-libs/libva-intel-media-driver-${PV}
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_OPENCL=OFF
	)

	cmake_src_configure
}
