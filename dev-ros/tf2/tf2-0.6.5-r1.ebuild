# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="The second generation Transform Library in ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/tf2_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/console_bridge:=
	dev-ros/rostime
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/boost:=[threads]
"
DEPEND="${RDEPEND}
	test? ( dev-ros/roscpp )
"
PATCHES=( "${FILESDIR}/boost.patch" )
