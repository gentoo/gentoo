# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/calibration"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/geometry_msgs dev-ros/actionlib_msgs dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Extracts checkerboard corners from ROS images"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/actionlib[${PYTHON_USEDEP}]
	dev-ros/cv_bridge[${PYTHON_USEDEP}]
	media-libs/opencv:=
	dev-ros/image_transport
	dev-ros/message_filters
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/calibration_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-libs/boost:=[threads]
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/gcc6.patch" "${FILESDIR}/c11.patch" "${FILESDIR}/boost170.patch" )
