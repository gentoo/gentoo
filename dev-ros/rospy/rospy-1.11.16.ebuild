# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
CATKIN_HAS_MESSAGES=yes
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=clients/${PN}

inherit ros-catkin

DESCRIPTION="Python client library for ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-ros/rosgraph[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_install() {
	ros-catkin_src_install
	# Other tests need these nodes
	exeinto /usr/share/${PN}
	doexe test_nodes/*
}
