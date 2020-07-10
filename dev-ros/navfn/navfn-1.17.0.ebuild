# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs dev-ros/geometry_msgs dev-ros/nav_msgs"
CATKIN_HAS_MESSAGES=yes
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Fast interpolated navigation function that can be used to create plans for a mobile base"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-ros/costmap_2d-1.16
	dev-ros/nav_core
	dev-ros/pluginlib
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_ros
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]

	dev-cpp/eigen:3
	x11-libs/fltk
	media-libs/netpbm
	dev-libs/boost:=[threads]
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
	dev-ros/cmake_modules"

PATCHES=( "${FILESDIR}/pgm_h_location.patch" "${FILESDIR}/tests.patch" )

src_prepare() {
	ros-catkin_src_prepare
	sed -e "s#@PGM_PATH@#\"${S}/test/willow_costmap.pgm\"#" -i test/path_calc_test.cpp || die
}
