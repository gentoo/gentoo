# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes

inherit ros-catkin

DESCRIPTION="The second generation Transform Library in ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf2_ros[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/python_orocos_kdl[\${PYTHON_USEDEP}]")
	dev-ros/tf2
	sci-libs/orocos_kdl
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-cpp/gtest
	)
"
