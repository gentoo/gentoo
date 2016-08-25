# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-simulation/gazebo_ros_pkgs"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="ROS control plugins for gazebo"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/gazebo_ros
	dev-ros/control_toolbox
	dev-ros/controller_manager
	dev-ros/hardware_interface
	dev-ros/transmission_interface
	dev-ros/pluginlib
	>=dev-ros/joint_limits_interface-0.11.0
	>=dev-ros/urdf-1.12.3-r1
	dev-libs/urdfdom:=
	sci-electronics/gazebo
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/urdfdom1.patch" )
