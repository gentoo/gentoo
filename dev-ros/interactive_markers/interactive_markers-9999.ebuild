# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros-visualization/interactive_markers"
KEYWORDS="~amd64"

inherit ros-catkin

DESCRIPTION="3D interactive marker communication library for RViz and similar tools"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/tf2_ros

	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? ( dev-cpp/gtest )"
