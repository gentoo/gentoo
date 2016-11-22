# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=test/${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Unit tests for rosgraph"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/rostest[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-ros/rosgraph[${PYTHON_USEDEP}] )
"
