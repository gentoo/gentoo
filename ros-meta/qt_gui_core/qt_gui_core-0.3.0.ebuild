# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros-visualization/qt_gui_core"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Integration of the ROS package system and ROS-specific plugins for a Qt-based GUI"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/qt_dotgraph
	dev-ros/qt_gui
	dev-ros/qt_gui_app
	dev-ros/qt_gui_cpp
	dev-ros/qt_gui_py_common
"
DEPEND="${RDEPEND}"
