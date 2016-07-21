# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/metapackages"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Metapackage for a basic ROS desktop install"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	ros-meta/robot
	ros-meta/viz
	dev-ros/roslint
	ros-meta/rqt_common_plugins
	ros-meta/rqt_robot_plugins
	dev-ros/urdf_tutorial
	ros-meta/visualization_tutorials
"
DEPEND="${RDEPEND}"
