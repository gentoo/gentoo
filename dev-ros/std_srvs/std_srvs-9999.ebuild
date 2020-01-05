# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/ros_comm_msgs"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_6} pypy3 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Messages relating to ROS comm"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
