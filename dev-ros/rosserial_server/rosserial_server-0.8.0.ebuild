# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
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
	dev-ros/rosserial_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/topic_tools
	dev-libs/boost:=[threads]
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/boost170.patch" )
