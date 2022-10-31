# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="KDL binding for tf2"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/tf2
	dev-ros/tf2_ros
	$(python_gen_cond_dep "dev-python/python_orocos_kdl[\${PYTHON_USEDEP}]")
	sci-libs/orocos_kdl:=
	dev-ros/tf2_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules
	dev-cpp/eigen:3
	test? (
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-cpp/gtest
	)"
