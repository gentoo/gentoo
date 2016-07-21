# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros-planning/shape_tools"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Tools for operating on shape messages"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/shape_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e 's/DESTINATION lib/DESTINATION ${CMAKE_INSTALL_LIBDIR}/' \
		-i CMakeLists.txt \
		|| die
}
