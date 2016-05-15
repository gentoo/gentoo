# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/bond_core"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="C++ implementation of bond, a mechanism for checking when another process has terminated"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/bond
	dev-ros/cmake_modules
	dev-ros/roscpp
	dev-ros/smclib
	dev-libs/boost:=
	sys-apps/util-linux
"
DEPEND="${RDEPEND}"
