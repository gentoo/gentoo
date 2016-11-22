# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/tu-darmstadt-ros-pkg/hector_slam"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Service for retrieving the map, as well as for raycasting based obstacle queries"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/hector_map_tools
	dev-ros/hector_marker_drawing
	dev-ros/hector_nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf
"
DEPEND="${RDEPEND}"
