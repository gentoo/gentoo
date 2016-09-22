# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-drivers/rosserial"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Libraries and examples for ROSserial usage on Arduino/AVR Platforms"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/rosserial_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rosserial_client[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
