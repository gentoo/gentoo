# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/common_tutorials"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Metapackage that contains common tutorials"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/actionlib_tutorials
	dev-ros/nodelet_tutorial_math
	dev-ros/pluginlib_tutorials
	dev-ros/turtle_actionlib
"
DEPEND="${RDEPEND}"
