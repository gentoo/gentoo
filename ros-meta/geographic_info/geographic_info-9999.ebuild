# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros-geographic-info/geographic_info"
VER_PREFIX=${PN}-
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Geographic information metapackage"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/geodesy
	dev-ros/geographic_msgs
"
DEPEND="${RDEPEND}"
