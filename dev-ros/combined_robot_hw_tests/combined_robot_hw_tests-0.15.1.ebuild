# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-controls/ros_control"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Combined Robot HW class tests"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/combined_robot_hw
	dev-ros/controller_manager
	dev-ros/controller_manager_tests
	dev-ros/hardware_interface
	dev-ros/roscpp
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest[${PYTHON_USEDEP}] )"
