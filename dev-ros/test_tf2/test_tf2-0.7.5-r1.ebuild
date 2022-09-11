# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="TF2 unit tests"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf
	dev-ros/tf2
	dev-ros/tf2_bullet
	dev-ros/tf2_eigen
	dev-ros/tf2_ros[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf2_geometry_msgs[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf2_kdl[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf2_msgs
	dev-ros/rosbash
	sci-libs/orocos_kdl
	$(python_gen_cond_dep "dev-python/python_orocos_kdl[\${PYTHON_USEDEP}]")
	dev-libs/boost:=
	dev-cpp/gtest
"

mycatkincmakeargs=( "-DCATKIN_ENABLE_TESTING=ON" )
