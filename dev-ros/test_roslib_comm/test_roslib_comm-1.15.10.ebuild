# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=test/${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/rosgraph_msgs dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Unit tests for roslib"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
		dev-ros/test_rosmaster
		dev-ros/std_srvs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	)
"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
