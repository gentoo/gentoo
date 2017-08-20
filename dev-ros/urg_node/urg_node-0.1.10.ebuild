# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-drivers/urg_node"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="ROS wrapper for the Hokuyo urg_c library"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/urg_c
	dev-ros/tf
	dev-ros/dynamic_reconfigure[${PYTHON_USEDEP}]
	dev-ros/nodelet
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/diagnostic_updater
	dev-ros/laser_proc
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}"
