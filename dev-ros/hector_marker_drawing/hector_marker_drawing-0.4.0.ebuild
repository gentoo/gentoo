# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/tu-darmstadt-ros-pkg/hector_slam"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Convenience functions for easier publishing of visualization markers"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3"
