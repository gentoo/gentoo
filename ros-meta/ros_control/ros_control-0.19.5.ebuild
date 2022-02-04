# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-controls/ros_control"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Controller interfaces, managers, transmissions, control_toolbox"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/combined_robot_hw
	dev-ros/combined_robot_hw_tests
	dev-ros/controller_interface
	dev-ros/controller_manager
	dev-ros/controller_manager_msgs
	dev-ros/controller_manager_tests
	dev-ros/hardware_interface
	dev-ros/joint_limits_interface
	dev-ros/rqt_controller_manager
	dev-ros/transmission_interface
"
DEPEND="${RDEPEND}"
