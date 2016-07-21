# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/calibration"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/actionlib_msgs	dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Extracts checkerboard corners from a dense laser snapshot"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=[threads]
	dev-ros/actionlib[${PYTHON_USEDEP}]
	dev-ros/cv_bridge
	dev-ros/image_cb_detector
	dev-ros/message_filters
	dev-ros/roscpp
	dev-ros/settlerlib
"
DEPEND="${RDEPEND}"
