# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=test/${PN}
CATKIN_HAS_MESSAGES=yes
PYTHON_COMPAT=( python2_7 )
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/rosgraph_msgs dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Unit tests for roscpp"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-ros/roscpp
	dev-ros/rostest[${PYTHON_USEDEP}]
	dev-ros/rosunit[${PYTHON_USEDEP}]
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/boost:=[threads]
	test? (
		dev-cpp/gtest
	)
"
REQUIRED_USE="test? ( ros_messages_cxx )"
