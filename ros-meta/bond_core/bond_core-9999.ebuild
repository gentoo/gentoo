# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/bond_core"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="A bond allows two processes, A and B, to know when the other has terminated"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/bond
	dev-ros/bondcpp
	dev-ros/bondpy
	dev-ros/smclib
	dev-ros/test_bond
"
DEPEND="${RDEPEND}"
