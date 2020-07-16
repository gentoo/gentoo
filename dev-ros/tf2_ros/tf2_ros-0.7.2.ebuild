# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="ROS bindings for the tf2 library, for both Python and C++"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/actionlib[${PYTHON_USEDEP}]
	dev-ros/message_filters
	dev-ros/roscpp
	dev-ros/rosgraph
	dev-libs/boost:=[threads]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/tf2
	dev-ros/tf2_py[${PYTHON_USEDEP}]
	dev-ros/actionlib_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/tf2_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest[${PYTHON_USEDEP}] )
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
