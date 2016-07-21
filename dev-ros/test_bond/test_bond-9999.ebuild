# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/bond_core"
KEYWORDS="~amd64 ~arm"
CATKIN_HAS_MESSAGES=yes
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Tests for bond, bondpy and bondcpp"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/bondcpp
	dev-ros/bondpy[${PYTHON_USEDEP}]
	dev-ros/rostest[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
