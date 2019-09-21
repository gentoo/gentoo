# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [[ ${PV} == *9999 ]] ; then
	: ${EGIT_REPO_URI:="https://github.com/intel/media-driver"}
	if [[ ${PV%9999} != "" ]] ; then
		: ${EGIT_BRANCH:="release/${PV%.9999}"}
	fi
	inherit git-r3
fi

DESCRIPTION="Intel Media Driver for VAAPI (iHD)"
HOMEPAGE="https://github.com/intel/media-driver"
if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/intel/media-driver/archive/intel-media-${PV}.tar.gz"
	S="${WORKDIR}/media-driver-intel-media-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="MIT BSD"
SLOT="0"
IUSE=""

DEPEND=">=media-libs/gmmlib-${PV}
	>=x11-libs/libva-2.3.0
	>=x11-libs/libpciaccess-0.13.1-r1:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DMEDIA_RUN_TEST_SUITE=OFF
	)

	cmake-utils_src_configure
}
