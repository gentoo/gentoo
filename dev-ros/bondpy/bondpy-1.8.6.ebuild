# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/bond_core"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Python implementation of bond, for checking when another process has terminated"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/bond[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/smclib
	sys-apps/util-linux
"
DEPEND="${RDEPEND}"
