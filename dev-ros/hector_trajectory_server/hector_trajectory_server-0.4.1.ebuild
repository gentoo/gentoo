# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/tu-darmstadt-ros-pkg/hector_slam"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Keeps track of tf trajectories and makes this data accessible"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/hector_map_tools
	dev-ros/tf
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/hector_nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
