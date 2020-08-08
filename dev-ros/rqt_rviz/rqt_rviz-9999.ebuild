# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_rviz"

inherit ros-catkin

DESCRIPTION="GUI plugin embedding RViz"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-ros/pluginlib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui_cpp
	>=dev-ros/qt_gui_cpp-0.3
	dev-qt/qtwidgets:5
	dev-ros/rviz
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}"
