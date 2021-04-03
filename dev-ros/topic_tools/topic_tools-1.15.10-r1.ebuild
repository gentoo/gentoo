# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
CATKIN_HAS_MESSAGES=yes
ROS_SUBDIR=tools/${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Tools for directing, throttling and selecting ROS topics"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cpp_common
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/rostime
	dev-ros/xmlrpcpp
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-ros/rosunit[${PYTHON_SINGLE_USEDEP}]
		dev-ros/rosbash[${PYTHON_SINGLE_USEDEP}]
		dev-ros/rostopic[${PYTHON_SINGLE_USEDEP}]
		dev-ros/rosmsg[${PYTHON_SINGLE_USEDEP}]
		dev-cpp/gtest
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
	)"
