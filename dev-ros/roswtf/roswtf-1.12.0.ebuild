# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=utilities/${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Tool for diagnosing issues with a running ROS system"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-ros/rostest[${PYTHON_USEDEP}]
		dev-util/rosdep[${PYTHON_USEDEP}]
		dev-util/rosinstall[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

src_test() {
	rosdep update
	ros-catkin_src_test
}
