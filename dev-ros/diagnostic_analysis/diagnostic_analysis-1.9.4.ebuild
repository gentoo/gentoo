# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/diagnostics"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Converts diagnostics data into a series of CSV files"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-ros/rosbag[${PYTHON_USEDEP}]
	dev-ros/rostest[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
