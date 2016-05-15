# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-visualization/visualization_tutorials"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Metapackage referencing tutorials related to rviz and visualization"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/interactive_marker_tutorials
	dev-ros/librviz_tutorial
	dev-ros/rviz_plugin_tutorials
	dev-ros/rviz_python_tutorial
	dev-ros/visualization_marker_tutorials
"
DEPEND="${RDEPEND}"
