# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/angles"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Set of simple math utilities to work with angles"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-python/pyxml"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
