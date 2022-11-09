# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Transform sensor_msgs with tf. Most notably, PointCloud2"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/tf2_ros[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf2
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/python_orocos_kdl[\${PYTHON_USEDEP}]")
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
		dev-cpp/gtest
	)
	dev-ros/cmake_modules
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-cpp/eigen:3
"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
