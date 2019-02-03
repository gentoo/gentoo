# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="Protobuf messages and functions for robot applications"
HOMEPAGE="https://ignitionrobotics.org/libraries/messages https://bitbucket.org/ignitionrobotics/ign-msgs"
SRC_URI="https://osrf-distributions.s3.amazonaws.com/ign-msgs/releases/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/protobuf:=[${MULTILIB_USEDEP}]
	sci-libs/ignition-math:4=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	dev-util/ignition-cmake[${MULTILIB_USEDEP}]"
CMAKE_BUILD_TYPE=RelWithDebInfo
