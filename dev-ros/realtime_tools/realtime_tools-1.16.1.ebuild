# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-controls/realtime_tools"
KEYWORDS="~amd64"

inherit ros-catkin

DESCRIPTION="Set of tools that can be used from a hard realtime thread"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
		dev-cpp/gtest
		dev-ros/actionlib
	)
"
PATCHES=( "${FILESDIR}/atomic.patch" )
