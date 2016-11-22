# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Implementation of an efficient 3D voxel grid"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/roscpp"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
