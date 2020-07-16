# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE=RelWithDebInfo
inherit cmake-utils

IGN_MAJOR=3

DESCRIPTION="Set of libraries designed to rapidly develop robot applications"
HOMEPAGE="https://ignitionrobotics.org/libs/common https://github.com/ignitionrobotics/ign-common"
SRC_URI="https://github.com/ignitionrobotics/ign-common/archive/${PN}${IGN_MAJOR}_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="${IGN_MAJOR}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/tinyxml2:=
	sci-libs/ignition-math:6=
	sys-apps/util-linux
	media-libs/freeimage:=
	sci-libs/gts:=
	media-video/ffmpeg:0=
"
DEPEND="${RDEPEND}
	dev-util/ignition-cmake:2"
BDEPEND="
	dev-util/ignition-cmake:2"

S="${WORKDIR}/ign-common-${PN}${IGN_MAJOR}_${PV}"

src_configure() {
	local mycmakeargs=(
		"-DBUILD_TESTING=OFF"
	)
	cmake-utils_src_configure
}
