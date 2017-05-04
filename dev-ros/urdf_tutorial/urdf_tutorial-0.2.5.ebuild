# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros/urdf_tutorial"
KEYWORDS="~amd64"

inherit ros-catkin

DESCRIPTION="URDF tutorials"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/urdf
	dev-ros/joint_state_publisher
	dev-ros/robot_state_publisher
	dev-ros/rviz
	dev-ros/xacro
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/notest.patch" )
