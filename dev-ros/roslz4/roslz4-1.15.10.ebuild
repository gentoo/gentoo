# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=utilities/${PN}

inherit ros-catkin

DESCRIPTION="Python and C++ implementation of the LZ4 streaming format"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="app-arch/lz4
	dev-ros/cpp_common"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
