# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/mavlink/mavros"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="MAVLink communication library"
LICENSE="GPL-3 LGPL-3 BSD"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-ros/mavlink-gbp-release-2016.7.7
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"
