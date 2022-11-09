# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/filters"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Standardized interface for processing data as a sequence of filters"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/roscpp
	dev-libs/boost:=
	dev-libs/console_bridge:=
	dev-ros/pluginlib"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest dev-cpp/gtest )"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	export CATKIN_PREFIX_PATH="${BUILD_DIR}/devel/:${CATKIN_PREFIX_PATH}"
	ros-catkin_src_test
}
