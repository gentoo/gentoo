# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}

inherit ros-catkin

DESCRIPTION="Assorted shell commands for using ros with bash"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/rospack"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/catkin_prefix.patch" )
