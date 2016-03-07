# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/geometry"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Conversion functions between KDL and geometry_msgs types"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	sci-libs/orocos_kdl
"
DEPEND="${RDEPEND}"
