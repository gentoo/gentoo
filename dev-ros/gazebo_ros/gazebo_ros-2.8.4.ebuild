# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-simulation/gazebo_ros_pkgs"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )
CATKIN_HAS_MESSAGES=yes
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="ROS plugins that offer message and service publishers for interfacing with gazebo"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/gazebo_dev
	dev-libs/tinyxml
	sci-electronics/gazebo:=
	dev-libs/protobuf:=
	dev-ros/gazebo_plugins[${PYTHON_USEDEP}]
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-ros/roscpp
	dev-ros/tf[${PYTHON_USEDEP}]
	dev-ros/dynamic_reconfigure
	dev-libs/libxml2
	dev-libs/boost:=[threads]
	dev-ros/gazebo_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rosgraph_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
