# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}

inherit ros-catkin

DESCRIPTION="Integration test suite based on roslaunch compatible with xUnit frameworks"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosunit[${PYTHON_SINGLE_USEDEP}]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
RDEPEND="${RDEPEND}
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/roslaunch[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosmaster[${PYTHON_SINGLE_USEDEP}]"
DEPEND="${DEPEND}
	test? (
		${RDEPEND}
		dev-ros/rosservice
		dev-cpp/gtest
		dev-ros/rostopic
	)"
