# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/metapackages"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Metapackage which extends ros_base and includes ROS libaries for any robot hardware"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	ros-meta/ros_base
	dev-ros/control_msgs
	ros-meta/diagnostics
	dev-ros/filters
	ros-meta/geometry
	ros-meta/robot_model
	dev-ros/robot_state_publisher
	dev-ros/xacro
	ros-meta/executive_smach
	dev-ros/actionlib
	ros-meta/bond_core
	dev-ros/class_loader
	dev-ros/dynamic_reconfigure
	ros-meta/common_tutorials
	ros-meta/nodelet_core
	dev-ros/pluginlib
"
DEPEND="${RDEPEND}"
