# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}

inherit ros-catkin

DESCRIPTION="Command-line tool for displaying debug information about ROS nodes"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/genmsg[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosgraph[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rostopic[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
	)"
