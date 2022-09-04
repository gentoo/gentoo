# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros-planning/random_numbers"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Wrappers for generating floating point values, integers and quaternions"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}"
