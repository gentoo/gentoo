# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/robot_state_publisher"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Package for publishing the state of a robot to tf"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/kdl_parser
	dev-cpp/eigen:3
	sci-libs/orocos_kdl:=
	dev-ros/roscpp
	dev-ros/rosconsole
	dev-ros/rostime
	dev-ros/tf2_ros
	dev-ros/tf2_kdl
	dev-ros/kdl_conversions
	dev-ros/sensor_msgs
	dev-ros/tf
	dev-ros/urdf
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest dev-ros/rostest[${PYTHON_SINGLE_USEDEP}] )
"
