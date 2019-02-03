# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="KDL binding for tf2"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-cpp/eigen:3
	dev-ros/tf2
	dev-ros/tf2_ros
	dev-python/python_orocos_kdl[${PYTHON_USEDEP}]
	sci-libs/orocos_kdl:=
	dev-ros/tf2_msgs[${PYTHON_USEDEP}]
	dev-ros/cmake_modules
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/rostest[${PYTHON_USEDEP}]
		dev-cpp/gtest
	)"
