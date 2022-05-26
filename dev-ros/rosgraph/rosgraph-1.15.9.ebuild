# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}

inherit ros-catkin

DESCRIPTION="Prints information about the ROS Computation Graph"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep "dev-python/netifaces[\${PYTHON_USEDEP}]")
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
"
DEPEND="${RDEPEND}
	test? (
		$(python_gen_cond_dep "dev-python/mock[\${PYTHON_USEDEP}]")
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
	)"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
