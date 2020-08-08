# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/joint_state_publisher"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Tool for setting and publishing joint state values for a given URDF"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/python_qt_binding[${PYTHON_SINGLE_USEDEP}]
	dev-ros/joint_state_publisher[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${DEPEND}
	test? ( dev-ros/rostest[${PYTHON_SINGLE_USEDEP}] )"
