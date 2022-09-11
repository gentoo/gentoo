# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/calibration"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/geometry_msgs dev-ros/actionlib_msgs dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Extracts checkerboard corners from ROS images"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/actionlib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/cv_bridge[${PYTHON_SINGLE_USEDEP}]
	media-libs/opencv:=
	dev-ros/image_transport
	dev-ros/message_filters
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/calibration_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
PATCHES=( "${FILESDIR}/gcc6.patch" "${FILESDIR}/c11.patch" "${FILESDIR}/py3.patch" )
