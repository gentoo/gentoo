# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="TF2 bullet support"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/tf2
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	sci-physics/bullet
"
DEPEND="${RDEPEND}"
