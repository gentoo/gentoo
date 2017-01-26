# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}
PYTHON_COMPAT=( python{2_7,3_4} )

inherit ros-catkin

DESCRIPTION="Tool for determining cflags/lflags/etc. of boost on your system"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
