# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/roslint"
KEYWORDS="~amd64 ~arm"

CMAKE_MAKEFILE_GENERATOR="emake" # https://bugs.gentoo.org/738584
inherit ros-catkin

DESCRIPTION="Static checking of Python or C++ source code for errors and standards compliance"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
