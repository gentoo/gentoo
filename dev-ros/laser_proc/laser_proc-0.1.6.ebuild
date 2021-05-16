# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/laser_proc"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Converts representations of LaserScan and MultiEchoLaserScan"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/rosconsole
	dev-libs/console_bridge:=
	dev-ros/pluginlib
	dev-ros/nodelet
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
