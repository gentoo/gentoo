# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Tools for 2nd gen Transform library"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/tf2_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf2_py[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf2_ros[${PYTHON_SINGLE_USEDEP}]
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/pyyaml[\${PYTHON_USEDEP}]")
"
DEPEND="${RDEPEND}"
