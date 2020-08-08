# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/geometry"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Functions to convert common tf datatypes into those used by other libraries"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/kdl_conversions
	dev-ros/tf[${PYTHON_SINGLE_USEDEP}]
	sci-libs/orocos_kdl:=
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/python_orocos_kdl[\${PYTHON_USEDEP}]")
	$(python_gen_cond_dep "dev-python/numpy[\${PYTHON_USEDEP}]")
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-cpp/gtest
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
	)"
