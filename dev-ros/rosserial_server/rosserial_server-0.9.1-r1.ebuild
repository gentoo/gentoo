# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-drivers/rosserial"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="C++ implementation of the rosserial server side"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/topic_tools
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/rosserial_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
