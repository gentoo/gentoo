# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=core/${PN}

inherit ros-catkin

DESCRIPTION="Common package for all ROS client libraries"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
