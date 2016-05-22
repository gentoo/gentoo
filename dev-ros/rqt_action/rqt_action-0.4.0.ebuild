# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_common_plugins"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Introspect all available ROS action (from actionlib) types"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/rqt_msg[${PYTHON_USEDEP}]
	dev-ros/rqt_py_common[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
