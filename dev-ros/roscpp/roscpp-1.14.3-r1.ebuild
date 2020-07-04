# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
CATKIN_HAS_MESSAGES=yes
ROS_SUBDIR=clients/${PN}

inherit ros-catkin

DESCRIPTION="C++ implementation of ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cpp_common
	dev-ros/rosconsole
	dev-ros/roscpp_serialization
	dev-ros/roscpp_traits
	dev-ros/rostime
	dev-ros/xmlrpcpp
	dev-libs/boost:=
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/rosgraph_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/boost.patch" )
