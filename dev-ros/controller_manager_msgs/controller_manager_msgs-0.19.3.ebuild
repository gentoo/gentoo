# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-controls/ros_control"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="The controller manager"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]"
DEPEND="${RDEPEND}"
