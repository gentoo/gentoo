# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/xacro"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="XML macro language"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/roslint[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest[${PYTHON_USEDEP}] dev-python/nose[${PYTHON_USEDEP}] )
"
RDEPEND="${RDEPEND}
	dev-ros/roslaunch[${PYTHON_USEDEP}]"
