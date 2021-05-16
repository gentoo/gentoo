# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_environment"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="ROS environment variables"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="!!<dev-ros/roslib-1.14.3"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/catkinprefixpath.patch" )

src_configure() {
	export ROS_DISTRO="Gentoo"
	export ROS_DISTRO_OVERRIDE="Gentoo"
	ros-catkin_src_configure
}
