# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=utilities/${PN}

inherit ros-catkin

DESCRIPTION="Tool for diagnosing issues with a running ROS system"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep "dev-python/paramiko[\${PYTHON_USEDEP}]")
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
	dev-ros/rosbuild[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosgraph[${PYTHON_SINGLE_USEDEP}]
	dev-ros/roslaunch[${PYTHON_SINGLE_USEDEP}]
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosnode[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosservice[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-ros/rosbag[${PYTHON_SINGLE_USEDEP}]
		dev-ros/roslang[${PYTHON_SINGLE_USEDEP}]
		dev-ros/std_srvs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
		$(python_gen_cond_dep "dev-util/rosdep[\${PYTHON_USEDEP}]")
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
	)"
BDEPEND="
	test? (
		dev-ros/cmake_modules
	)
"

src_test() {
	# Needed for tests to find internal launch file
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
