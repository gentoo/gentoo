# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

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
	app-crypt/gpgme
	dev-ros/pluginlib
	dev-ros/cpp_common
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
DEPEND="${RDEPEND}"
