# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-controls/ros_control"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Hardware Interface base class"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/roscpp"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest dev-ros/rostest )"
