# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-simulation/gazebo_ros_pkgs"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )
CATKIN_HAS_MESSAGES=yes
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Robot-independent Gazebo plugins for sensors, motors and dynamic reconfigurable components"
LICENSE="BSD Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/gazebo_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/roscpp
	dev-ros/rospy
	dev-ros/nodelet
	dev-ros/angles
	dev-ros/std_srvs
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/urdf
	dev-ros/tf
	dev-ros/tf2_ros
	dev-ros/dynamic_reconfigure
	dev-ros/driver_base
	dev-ros/rosgraph_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/trajectory_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/pcl_conversions
	dev-ros/image_transport
	dev-ros/rosconsole
	dev-ros/cv_bridge
	dev-ros/polled_camera
	dev-ros/diagnostic_updater
	dev-ros/camera_info_manager
	dev-ros/moveit_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/libxml2
	>=sci-electronics/gazebo-7:=
	dev-games/ogre
	sci-libs/pcl
	dev-libs/boost:=
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-ros/roslib[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
