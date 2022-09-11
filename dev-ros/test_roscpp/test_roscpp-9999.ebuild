# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=test/${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/rosgraph_msgs dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Unit tests for roscpp"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-ros/roscpp
	dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosunit[${PYTHON_SINGLE_USEDEP}]
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/boost:=
	test? (
		dev-cpp/gtest
	)
"
REQUIRED_USE="test? ( ros_messages_cxx )"
PATCHES=( "${FILESDIR}/tests.patch" )

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	# Sometimes high number of tests running in parallel make them fail
	# https://bugs.gentoo.org/738620
	ros-catkin_src_test -j 1
}
