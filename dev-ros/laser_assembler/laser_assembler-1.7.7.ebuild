# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/laser_assembler"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/sensor_msgs dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Nodes to assemble point clouds from either LaserScan or PointCloud messages"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-libs/boost:=
	dev-ros/tf
	dev-ros/laser_geometry[${PYTHON_USEDEP}]
	dev-ros/pluginlib
	dev-libs/tinyxml2:=
	dev-libs/console_bridge:=
	dev-ros/message_filters[${PYTHON_USEDEP}]
	dev-ros/filters
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest[${PYTHON_USEDEP}] dev-cpp/gtest )
"
