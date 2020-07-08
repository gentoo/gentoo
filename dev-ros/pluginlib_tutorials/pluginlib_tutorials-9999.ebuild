# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/common_tutorials"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Pluginlib tutorials"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/pluginlib
		dev-libs/tinyxml2:=
		dev-libs/console_bridge:=
	dev-ros/roscpp
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
