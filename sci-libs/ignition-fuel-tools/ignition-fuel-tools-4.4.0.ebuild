# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE=RelWithDebInfo
inherit cmake

IGN_MAJOR=4

DESCRIPTION="Classes and tools for interacting with Ignition Fuel"
HOMEPAGE="https://github.com/ignitionrobotics/ign-fuel-tools/"
SRC_URI="https://github.com/ignitionrobotics/ign-fuel-tools/archive/${PN}${IGN_MAJOR}_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="${IGN_MAJOR}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/tinyxml2:=
	net-misc/curl:=
	dev-libs/jsoncpp:=
	dev-libs/libyaml:=
	dev-libs/libzip:=
	sci-libs/ignition-common:3=
	net-libs/ignition-msgs:5=
		dev-libs/protobuf:=
"
#igncurl
DEPEND="${RDEPEND}
	dev-build/ignition-cmake:2"
BDEPEND="
	dev-build/ignition-cmake:2"

S="${WORKDIR}/ign-fuel-tools-${PN}${IGN_MAJOR}_${PV}"

src_configure() {
	local mycmakeargs=(
		"-DBUILD_TESTING=$(usex test)"
	)
	cmake_src_configure
}
