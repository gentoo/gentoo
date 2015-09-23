# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros-visualization/rqt"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Enables GUI plugins to use the C++ client library for ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtgui:4
	dev-qt/qtcore:4
	dev-ros/qt_gui_cpp
	dev-ros/qt_gui
	dev-ros/roscpp
	dev-ros/nodelet
"
DEPEND="${RDEPEND}"
