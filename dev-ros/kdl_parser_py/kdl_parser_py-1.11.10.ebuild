# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/robot_model"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Python tools to construct a KDL tree from an XML robot representation in URDF"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/urdf[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest[${PYTHON_USEDEP}] )"
