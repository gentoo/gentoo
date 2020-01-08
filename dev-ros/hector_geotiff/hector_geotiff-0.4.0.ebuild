# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/tu-darmstadt-ros-pkg/hector_slam"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Node to save occupancy grid map, robot trajectory and object of interest data to GeoTiff images"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/hector_map_tools
	dev-ros/hector_nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/pluginlib
		dev-libs/tinyxml2:=
	dev-libs/console_bridge:=
	dev-ros/roscpp
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3"

PATCHES=( "${FILESDIR}/qt5.patch" )
