# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Protobuf messages and functions for robot applications"
HOMEPAGE="https://github.com/ignitionrobotics/ign-msgs"
SRC_URI="https://github.com/ignitionrobotics/ign-msgs/archive/${PN}5_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/protobuf:=
	sci-libs/ignition-math:6=
	dev-libs/tinyxml2:=
"
DEPEND="${RDEPEND}
	dev-util/ignition-cmake:2"
BDEPEND="dev-util/ignition-cmake:2"
CMAKE_BUILD_TYPE=RelWithDebInfo
S="${WORKDIR}/gz-msgs-ignition-msgs5_${PV}"
PATCHES=( "${FILESDIR}/std.patch" )
