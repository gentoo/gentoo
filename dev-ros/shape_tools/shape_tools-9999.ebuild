# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros-planning/shape_tools"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Tools for operating on shape messages"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
"
DEPEND="${RDEPEND}
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/shape_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"

src_prepare() {
	cmake-utils_src_prepare

	sed -e 's/DESTINATION lib/DESTINATION ${CMAKE_INSTALL_LIBDIR}/' \
		-i CMakeLists.txt \
		|| die
}
