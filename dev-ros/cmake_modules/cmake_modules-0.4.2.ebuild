# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/cmake_modules"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="CMake Modules which are not distributed with CMake but are commonly used by ROS packages"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
