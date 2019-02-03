# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=test/${PN}

inherit ros-catkin

DESCRIPTION="Unit tests for rosbag_storage"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-ros/rosbag_storage
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/boost:=
	test? ( dev-cpp/gtest )"
