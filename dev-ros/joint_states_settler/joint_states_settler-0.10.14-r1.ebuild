# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/calibration"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Reports how long a subset of joints has been settled"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-ros/actionlib
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/roscpp_serialization
	dev-ros/settlerlib
"
DEPEND="${RDEPEND}
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/actionlib_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? ( dev-cpp/gtest )"
PATCHES=( "${FILESDIR}/gcc6.patch" )
