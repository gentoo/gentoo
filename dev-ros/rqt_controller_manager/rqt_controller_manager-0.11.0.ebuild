# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-controls/ros_control"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="RQT control manager plugin"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/controller_manager[${PYTHON_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
