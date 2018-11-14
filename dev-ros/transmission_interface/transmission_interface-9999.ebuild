# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-controls/ros_control"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Transmission Interface"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/hardware_interface
	dev-ros/pluginlib
		dev-libs/tinyxml2:=
	dev-libs/console_bridge:=
	dev-ros/resource_retriever
	dev-ros/roscpp
	dev-libs/tinyxml
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
