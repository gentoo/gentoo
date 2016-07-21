# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/class_loader"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="ROS-independent package for loading plugins"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/poco
	dev-libs/boost:=[threads]
	dev-ros/cmake_modules
	dev-libs/console_bridge"
DEPEND="${RDEPEND}"
