# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=utilities/${PN}

inherit ros-catkin

DESCRIPTION="C++ implementation of the XML-RPC protocol"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cpp_common
	dev-ros/rostime
"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-libs/boost
	)
"
