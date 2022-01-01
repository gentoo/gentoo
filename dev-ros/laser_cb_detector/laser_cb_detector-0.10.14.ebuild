# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/calibration"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/actionlib_msgs	dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Extracts checkerboard corners from a dense laser snapshot"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=[threads]
	dev-ros/actionlib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/cv_bridge
	media-libs/opencv:=
	dev-ros/image_cb_detector
	dev-ros/message_filters
	dev-ros/roscpp
	dev-ros/settlerlib
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/gcc6.patch" "${FILESDIR}/boost170.patch" "${FILESDIR}/ocv4.patch" )
