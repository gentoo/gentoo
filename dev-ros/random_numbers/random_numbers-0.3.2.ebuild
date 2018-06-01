# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros-planning/random_numbers"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Wrappers for generating floating point values, integers, quaternions using boost libraries"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/boost:=[threads]"
DEPEND="${RDEPEND}"
