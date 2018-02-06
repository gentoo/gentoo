# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_environment"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy{,3} )

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
