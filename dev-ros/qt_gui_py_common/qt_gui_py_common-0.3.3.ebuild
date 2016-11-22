# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros-visualization/qt_gui_core"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Common functionality for ROS RQT GUI plugins written in Python"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/rospkg[${PYTHON_USEDEP}]
	>=dev-ros/python_qt_binding-0.3.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
