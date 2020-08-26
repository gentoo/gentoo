# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/nodelet_core"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Nodelet topic tools unit tests"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/message_filters
	dev-ros/nodelet
	dev-ros/nodelet_topic_tools
	dev-ros/pluginlib
	dev-ros/roscpp
	dev-ros/rostest
	dev-ros/rosmsg[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	export CATKIN_PREFIX_PATH="${BUILD_DIR}/devel/:${CATKIN_PREFIX_PATH}"
	ros-catkin_src_test
}
