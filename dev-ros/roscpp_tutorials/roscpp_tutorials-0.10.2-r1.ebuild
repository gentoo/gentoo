# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/ros_tutorials"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Attempts to show the features of ROS step-by-step"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-ros/rostime
	dev-ros/roscpp
	dev-ros/rosconsole
	dev-ros/roscpp_serialization
"
DEPEND="${RDEPEND}"
