# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}

inherit ros-catkin

DESCRIPTION="Set of tools for recording from and playing back ROS message"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/console_bridge

	dev-ros/cpp_common
	>=dev-ros/pluginlib-1.13.0-r2:=
	dev-ros/roscpp_serialization
	dev-ros/roscpp_traits
	dev-ros/rostime
	dev-ros/roslz4

	dev-libs/boost:=
	app-arch/bzip2
	dev-libs/console_bridge:=
	dev-libs/tinyxml2:=

	dev-libs/openssl:0=
	app-crypt/gpgme
"
DEPEND="${RDEPEND}
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-ros/rostest
		dev-cpp/gtest
	)
"
