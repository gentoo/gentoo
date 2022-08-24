# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE=RelWithDebInfo
inherit cmake

IGN_MAJOR=3

DESCRIPTION="Set of libraries designed to rapidly develop robot applications"
HOMEPAGE="https://github.com/ignitionrobotics/ign-common"
SRC_URI="https://github.com/ignitionrobotics/ign-common/archive/${PN}${IGN_MAJOR}_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="${IGN_MAJOR}"
KEYWORDS="~amd64"
IUSE="test"
#RESTRICT="!test? ( test )"
# tests dont even build
RESTRICT="test"

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

S="${WORKDIR}/gz-common-ignition-common${IGN_MAJOR}_${PV}"
PATCHES=( "${FILESDIR}/ffmpeg5.patch" )

src_configure() {
	local mycmakeargs=(
		"-DBUILD_TESTING=$(usex test)"
	)
	cmake_src_configure
}
