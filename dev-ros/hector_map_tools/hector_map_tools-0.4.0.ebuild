# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/tu-darmstadt-ros-pkg/hector_slam"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Functions related to accessing information from OccupancyGridMap maps"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]"
DEPEND="${RDEPEND}"
