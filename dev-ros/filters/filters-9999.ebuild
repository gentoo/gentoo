# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/filters"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Standardized interface for processing data as a sequence of filters"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/roscpp
	dev-libs/boost:=[threads]
	dev-ros/pluginlib"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest dev-cpp/gtest )"
PATCHES=( "${FILESDIR}/tests.patch" "${FILESDIR}/rostest.patch" )
