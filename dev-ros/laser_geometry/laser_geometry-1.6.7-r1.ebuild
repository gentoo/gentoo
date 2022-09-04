# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/laser_geometry"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Class for converting from a 2D laser scan into a point cloud"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/angles:0
	dev-ros/roscpp
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/numpy[\${PYTHON_USEDEP}]")
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/tf
	dev-ros/tf2[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf2_geometry_msgs[${PYTHON_SINGLE_USEDEP}]
	dev-libs/boost:=
	dev-cpp/eigen:3
"
DEPEND="${RDEPEND}
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-cpp/gtest
	)"
BDEPEND="
	dev-ros/cmake_modules
"
