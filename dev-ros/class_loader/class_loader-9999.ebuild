# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/class_loader"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="ROS-independent package for loading plugins"
LICENSE="BSD"
SLOT="0/melodic2"
IUSE=""

RDEPEND="dev-libs/poco
	dev-libs/boost:=
	dev-libs/console_bridge:="
DEPEND="${RDEPEND}"
BDEPEND="
	dev-ros/cmake_modules
"
