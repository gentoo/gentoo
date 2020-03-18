# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/actionlib_msgs dev-ros/geometry_msgs"

inherit ros-catkin

DESCRIPTION="TF2 messages"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
