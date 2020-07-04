# Copyright 1999-2020 Gentoo Authors
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
	sci-physics/bullet:=
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/roscpp
	media-libs/sdl-image
	dev-ros/tf2
	>=dev-cpp/yaml-cpp-0.5:=

	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest dev-ros/rospy dev-ros/rosunit )
	virtual/pkgconfig"
