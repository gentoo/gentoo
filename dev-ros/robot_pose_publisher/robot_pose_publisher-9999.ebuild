# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/GT-RAIL/robot_pose_publisher"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="A Simple Node to Publish the Robot's Position Relative to the Map using TFs"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/tf
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}"
