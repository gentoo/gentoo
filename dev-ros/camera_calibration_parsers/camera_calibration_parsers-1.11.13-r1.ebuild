# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/image_common"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python{2_7,3_6} )

inherit ros-catkin

DESCRIPTION="Routines for reading and writing camera calibration parameters"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-libs/boost:=[python,${PYTHON_USEDEP}]
	dev-ros/rosconsole
	>=dev-cpp/yaml-cpp-0.5:=
	dev-ros/roscpp
	dev-ros/roscpp_serialization
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-python/nose )
"
PATCHES=( "${FILESDIR}/boostpython.patch" )
