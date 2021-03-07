# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_bag"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="GUI plugin for displaying and replaying ROS bag files"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	$(python_gen_cond_dep "dev-python/pycairo[\${PYTHON_USEDEP}]")
	$(python_gen_cond_dep "dev-python/pillow[\${PYTHON_USEDEP}]")
	dev-ros/rosbag[${PYTHON_SINGLE_USEDEP}]
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_bag[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_SINGLE_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
