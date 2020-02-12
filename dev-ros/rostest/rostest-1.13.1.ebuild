# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}
PYTHON_COMPAT=( python{2_7,3_6} pypy3 )

inherit ros-catkin

DESCRIPTION="Integration test suite based on roslaunch that is compatible with xUnit frameworks"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosunit[${PYTHON_USEDEP}]
	dev-libs/boost:=[threads]
"
DEPEND="${RDEPEND}"
RDEPEND="${RDEPEND}
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/roslaunch[${PYTHON_USEDEP}]
	dev-ros/rosmaster[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	test? (
		${RDEPEND}
		dev-cpp/gtest
	)"
