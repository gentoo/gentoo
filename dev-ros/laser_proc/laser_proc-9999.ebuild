# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/laser_proc"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Converts representations of sensor_msgs/LaserScan and sensor_msgs/MultiEchoLaserScan"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/rosconsole
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/pluginlib
	dev-ros/nodelet
"
DEPEND="${RDEPEND}"
