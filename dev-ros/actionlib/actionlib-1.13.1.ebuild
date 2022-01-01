# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/actionlib"
KEYWORDS="~amd64 ~arm"
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/actionlib_msgs dev-ros/std_msgs"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Provides a standardized interface for interfacing with preemptable tasks"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/boost:=[threads]
	dev-ros/roscpp
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-ros/rosunit[${PYTHON_SINGLE_USEDEP}]
	test? ( dev-ros/rostest[${PYTHON_SINGLE_USEDEP}] )"
RDEPEND="${RDEPEND}
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rostopic[${PYTHON_SINGLE_USEDEP}]
"
