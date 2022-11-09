# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="TF2 python bindings"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/tf2
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
