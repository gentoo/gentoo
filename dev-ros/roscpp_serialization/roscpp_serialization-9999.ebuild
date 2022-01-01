# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/roscpp_core"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Code for serialization"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cpp_common
	dev-ros/rostime
	dev-ros/roscpp_traits
"
DEPEND="${RDEPEND}"
