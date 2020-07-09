# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/geometry"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Conversion functions between Eigen and KDL and Eigen and geometry_msgs"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	sci-libs/orocos_kdl:=
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/cmake_modules
"
