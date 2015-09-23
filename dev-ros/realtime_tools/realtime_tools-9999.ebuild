# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-controls/realtime_tools"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Set of tools that can be used from a hard realtime thread, without breaking the realtime behavior"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
