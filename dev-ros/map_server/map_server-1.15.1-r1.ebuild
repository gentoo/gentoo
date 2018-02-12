# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Offers map data as a ROS service"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/tf
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/boost:=
	media-libs/sdl-image
	>=dev-cpp/yaml-cpp-0.5
	sci-physics/bullet:=
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest dev-cpp/gtest )
	virtual/pkgconfig"
