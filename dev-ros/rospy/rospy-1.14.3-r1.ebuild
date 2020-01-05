# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
CATKIN_HAS_MESSAGES=yes
PYTHON_COMPAT=( python{2_7,3_6} pypy3 )
ROS_SUBDIR=clients/${PN}

inherit ros-catkin

DESCRIPTION="Python client library for ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-ros/rosgraph[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]
	dev-ros/roscpp[${PYTHON_USEDEP}]
	dev-ros/rosgraph_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/yaml.patch" )

src_install() {
	ros-catkin_src_install
	# Other tests need these nodes
	exeinto /usr/share/${PN}
	doexe test_nodes/*
}
