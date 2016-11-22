# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/calibration"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Runs an optimization to estimate the a robot's kinematic parameters"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-ros/rosgraph[${PYTHON_USEDEP}]
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/calibration_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/python_orocos_kdl[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/urdf_parser_py[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest[${PYTHON_USEDEP}] dev-python/nose[${PYTHON_USEDEP}] )"
