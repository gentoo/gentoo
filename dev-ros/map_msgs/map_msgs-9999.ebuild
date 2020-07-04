# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation_msgs"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_6} pypy3 )
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs dev-ros/sensor_msgs dev-ros/nav_msgs"

inherit ros-catkin

DESCRIPTION="Messages commonly used in mapping packages"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
