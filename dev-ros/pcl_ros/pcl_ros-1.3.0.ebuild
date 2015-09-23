# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/perception_pcl"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="PCL (Point Cloud Library) ROS interface stack"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/rosbag
	dev-ros/rosconsole
	dev-ros/roslib
	dev-ros/dynamic_reconfigure[${PYTHON_USEDEP}]
	>=dev-cpp/eigen-3.2.5:3
	dev-ros/pluginlib
	dev-ros/tf
	dev-ros/tf2
	dev-ros/tf2_ros
	dev-ros/nodelet
	dev-ros/nodelet_topic_tools
	sci-libs/pcl[qhull]
	dev-ros/pcl_conversions
	dev-ros/pcl_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}"
