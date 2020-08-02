# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}

inherit ros-catkin

DESCRIPTION="Command-line tools for displaying information about message and services"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/genmsg[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosbag[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-ros/test_rosmaster[${PYTHON_SINGLE_USEDEP}] )
"
