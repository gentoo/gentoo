# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/RobotWebTools/rosbridge_suite"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Provides service calls for getting ros meta-information, like list of topics, services, params, etc."
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/rosnode[${PYTHON_USEDEP}]
	dev-ros/rosgraph[${PYTHON_USEDEP}]
	dev-ros/rosbridge_library[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
