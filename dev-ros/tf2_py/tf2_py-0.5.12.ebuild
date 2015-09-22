# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/geometry_experimental"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="TF2 python bindings"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/tf2
	dev-ros/rospy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
