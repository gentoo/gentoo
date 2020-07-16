# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-simulation/gazebo_ros_pkgs"
KEYWORDS="~amd64"
CATKIN_HAS_MESSAGES=yes
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Robot-independent Gazebo plugins"
LICENSE="BSD Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/gazebo_dev
	dev-ros/roscpp
	dev-ros/rospy
	dev-ros/nodelet
	dev-ros/angles
	dev-ros/std_srvs
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/urdf
	dev-ros/tf
	dev-ros/tf2_ros
	dev-ros/dynamic_reconfigure[${PYTHON_USEDEP}]
	dev-ros/driver_base[${PYTHON_USEDEP}]
	dev-ros/pcl_conversions
	dev-ros/image_transport
	dev-ros/rosconsole
	dev-ros/cv_bridge
	media-libs/opencv:=
	dev-ros/polled_camera
	dev-ros/diagnostic_updater
	dev-ros/camera_info_manager
	dev-libs/libxml2
	>=sci-electronics/gazebo-7:=
	dev-libs/protobuf:=
	dev-games/ogre
	sci-libs/pcl
	dev-libs/boost:=
	dev-ros/roslib[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-ros/gazebo_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/rosgraph_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/trajectory_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/moveit_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
PATCHES=( "${FILESDIR}/ocv4.patch" )
