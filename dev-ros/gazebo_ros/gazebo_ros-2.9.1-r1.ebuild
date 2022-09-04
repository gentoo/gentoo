# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-simulation/gazebo_ros_pkgs"
KEYWORDS="~amd64"
CATKIN_HAS_MESSAGES=yes
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="ROS plugins that offer messages and services for interfacing with gazebo"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/gazebo_dev
	dev-libs/tinyxml
	sci-electronics/gazebo:=
	dev-libs/protobuf:=
	dev-ros/gazebo_plugins[${PYTHON_SINGLE_USEDEP}]
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/roscpp
	dev-ros/tf[${PYTHON_SINGLE_USEDEP}]
	dev-ros/dynamic_reconfigure
	dev-libs/libxml2
	dev-libs/boost:=
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/std_srvs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-ros/gazebo_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/rosgraph_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
