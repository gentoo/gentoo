# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/pr2/pr2_common"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
PYTHON_COMPAT=( python{2_7,3_4} )
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs dev-ros/geometry_msgs"

inherit ros-catkin

DESCRIPTION="Messages for representing PR2 state, such as battery information and the PR2 fingertip sensors"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
