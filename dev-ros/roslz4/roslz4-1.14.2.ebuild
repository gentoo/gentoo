# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=utilities/${PN}

inherit ros-catkin

DESCRIPTION="Python and C++ implementation of the LZ4 streaming format"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="app-arch/lz4"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
