# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-controls/ros_control"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Tests for the controller manager"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/controller_manager[${PYTHON_SINGLE_USEDEP}]
	dev-ros/controller_interface
	dev-ros/control_toolbox
	dev-libs/boost:=
	dev-libs/console_bridge:=
	dev-cpp/gtest
"
DEPEND="${RDEPEND}
	dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
	dev-ros/rosservice[${PYTHON_SINGLE_USEDEP}]
"
# needed by combined_robot_hw_tests
mycatkincmakeargs=( "-DCATKIN_ENABLE_TESTING=ON" )

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	export CATKIN_PREFIX_PATH="${BUILD_DIR}/devel/:${CATKIN_PREFIX_PATH}"
	ros-catkin_src_test
}
