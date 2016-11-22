# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/common_msgs"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs dev-ros/sensor_msgs"

inherit ros-catkin

DESCRIPTION="Messages specific to stereo processing, such as disparity images"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
