# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/wg-perception/object_recognition_msgs"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_4} )
CATKIN_MESSAGES_TRANSITIVE_DEPS="
	dev-ros/actionlib_msgs
	dev-ros/geometry_msgs
	dev-ros/sensor_msgs
	dev-ros/shape_msgs
	dev-ros/std_msgs
"

inherit ros-catkin

DESCRIPTION="ROS message and the actionlib definition used in object_recognition_core"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
