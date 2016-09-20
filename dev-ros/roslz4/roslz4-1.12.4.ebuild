# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
ROS_SUBDIR=utilities/${PN}

inherit ros-catkin

DESCRIPTION="Python and C++ implementation of the LZ4 streaming format"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="app-arch/lz4"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
