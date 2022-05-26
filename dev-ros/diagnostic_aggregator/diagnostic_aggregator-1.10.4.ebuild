# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/diagnostics"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Aggregates ROS diagnostics"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/pluginlib:=
		dev-libs/tinyxml2:=
	dev-ros/roscpp
	dev-ros/rospy
	dev-ros/rostest
	dev-ros/xmlrpcpp
	dev-ros/bondcpp
	dev-libs/boost:=
	dev-libs/console_bridge:=
	dev-ros/bondpy[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? ( dev-ros/rostest[${PYTHON_SINGLE_USEDEP}] )"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	export CATKIN_PREFIX_PATH="${BUILD_DIR}/devel/:${CATKIN_PREFIX_PATH}"
	ros-catkin_src_test
}
