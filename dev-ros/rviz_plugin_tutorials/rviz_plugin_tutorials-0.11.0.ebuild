# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-visualization/visualization_tutorials"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Tutorials showing how to write plugins for RViz"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rviz
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}"
