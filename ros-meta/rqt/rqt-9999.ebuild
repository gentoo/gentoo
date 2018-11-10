# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros-visualization/rqt"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Qt-based framework for GUI development for ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rqt_gui
	dev-ros/rqt_gui_cpp
	dev-ros/rqt_gui_py
	dev-ros/rqt_py_common
"
DEPEND="${RDEPEND}"
