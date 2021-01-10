# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/pluginlib"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR="${PN}"

inherit ros-catkin

DESCRIPTION="Tools for writing and dynamically loading plugins using the ROS infrastructure"
LICENSE="BSD"
SLOT="0/${PV}"
IUSE=""

RDEPEND="
	>=dev-ros/class_loader-0.3.5:=
	dev-ros/rosconsole
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-libs/boost:=
	dev-libs/tinyxml2:=
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
PATCHES=( "${FILESDIR}/catkin_prefix_path2.patch" "${FILESDIR}/libdir.patch" )

src_test() {
	cmake_build tests

	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	export CATKIN_PREFIX_PATH=devel/
	ros-catkin_src_test
}
