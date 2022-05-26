# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/vision_opencv"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="C++ and Python libraries for interpreting images geometrically"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	media-libs/opencv:=
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
		dev-cpp/gtest
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
	)"
PATCHES=( "${FILESDIR}/ocv_leak.patch" )
