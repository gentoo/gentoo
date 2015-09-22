# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
ROS_SUBDIR=tools/${PN}

inherit ros-catkin

DESCRIPTION="Prints information about the ROS Computation Graph"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] dev-python/nose[${PYTHON_USEDEP}] )"
