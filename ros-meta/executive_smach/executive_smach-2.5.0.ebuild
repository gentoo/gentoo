# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/executive_smach"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="SMACH library and ROS SMACH integration packages"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/smach
	dev-ros/smach_ros
	dev-ros/smach_msgs
"
DEPEND="${RDEPEND}"
