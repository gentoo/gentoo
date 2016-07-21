# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=test/${PN}
CATKIN_HAS_MESSAGES=yes

PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Unit tests for rosmaster"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/rosgraph[${PYTHON_USEDEP}]
	dev-ros/rostest[${PYTHON_USEDEP}]
	dev-ros/std_msgs[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (	dev-ros/roslib[${PYTHON_USEDEP}] )
"

mycatkincmakeargs=( "-DCATKIN_ENABLE_TESTING=ON" )

src_install() {
	ros-catkin_src_install
	dodir /usr/share/${PN}
	cp -a test "${ED}//usr/share/${PN}/" || die
}
