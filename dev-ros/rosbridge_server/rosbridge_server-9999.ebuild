# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/RobotWebTools/rosbridge_suite"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="A WebSocket interface to rosbridge"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosapi[${PYTHON_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/rosbridge_library[${PYTHON_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rosauth[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"
