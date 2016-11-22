# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-controls/ros_control"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="The controller manager"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/rospy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
