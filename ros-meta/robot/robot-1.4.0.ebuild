# Copyright 1999-2018 Gentoo Foundation
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
	ros-meta/executive_smach
	dev-ros/filters
	ros-meta/geometry
	dev-ros/joint_state_publisher
	dev-ros/kdl_parser
	dev-ros/kdl_parser_py
	dev-ros/robot_state_publisher
	dev-ros/urdf
	dev-ros/urdf_parser_plugin
	dev-ros/xacro
"
DEPEND="${RDEPEND}"
