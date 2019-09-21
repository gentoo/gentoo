# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="A ROS node that simply forwards odometry information"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-ros/angles
	dev-ros/roscpp
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/rosconsole
	dev-ros/nav_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP},${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP},${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_ros
	dev-ros/message_filters
	dev-ros/tf2_geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/boost170.patch" )
