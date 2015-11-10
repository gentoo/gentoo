# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/RobotWebTools/rosbridge_suite"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs dev-ros/geometry_msgs"

inherit ros-catkin

DESCRIPTION="Core rosbridge package repsonsible for interpreting JSON and performing the appropriate ROS action"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/rosservice[${PYTHON_USEDEP}]
	dev-ros/rostopic[${PYTHON_USEDEP}]
	dev-ros/rosgraph[${PYTHON_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? (
		dev-ros/actionlib_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
		dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
		dev-ros/nav_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
		dev-ros/rospy_tutorials[${CATKIN_MESSAGES_PYTHON_USEDEP}]
		dev-ros/sensor_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
		dev-ros/std_srvs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
		dev-ros/stereo_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
		dev-ros/tf2_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
		dev-ros/trajectory_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
		dev-ros/visualization_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	)
"
