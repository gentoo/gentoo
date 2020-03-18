# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/std_msgs"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_6} pypy3 )

inherit ${SCM} ros-catkin

DESCRIPTION="Standard ROS Messages"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
