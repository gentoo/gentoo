# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros-visualization/rqt"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Enables GUI plugins to use the C++ client library for ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtwidgets:5
	dev-qt/qtcore:5
	>=dev-ros/qt_gui_cpp-0.3.0
	>=dev-ros/qt_gui-0.3.0
	dev-ros/roscpp
	dev-ros/nodelet
		dev-libs/tinyxml2:=
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}"
