# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/metapackages"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Metapackage for a basic ROS desktop install"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	ros-meta/robot
	ros-meta/viz
	dev-ros/angles
	ros-meta/common_tutorials
	ros-meta/geometry_tutorials
	dev-ros/joint_state_publisher_gui
	ros-meta/ros_tutorials
	dev-ros/roslint
	dev-ros/urdf_tutorial
	ros-meta/visualization_tutorials
"
DEPEND="${RDEPEND}"
