# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros/common_tutorials"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Nodelet tutorial"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/nodelet
	dev-libs/console_bridge:=
	dev-ros/roscpp
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
