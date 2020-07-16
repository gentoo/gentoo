# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros-drivers/nmea_msgs"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python{2_7,3_6} pypy3 )
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"
VER_PREFIX=${PN}-

inherit ros-catkin

DESCRIPTION="Messages related to data in the NMEA format"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
