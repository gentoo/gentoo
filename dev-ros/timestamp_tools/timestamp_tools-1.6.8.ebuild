# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-drivers/driver_common"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Classes to help timestamp hardware events"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roslib
	dev-ros/roscpp
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
PATCHES=( "${FILESDIR}/tests.patch" )
