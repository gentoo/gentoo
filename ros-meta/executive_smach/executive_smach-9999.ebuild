# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/executive_smach"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
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
