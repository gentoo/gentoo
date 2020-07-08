# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=test/${PN}
CATKIN_HAS_MESSAGES=yes

PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Unit tests for rosparam"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-ros/rostest[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-ros/rosparam[${PYTHON_USEDEP}]
	)"
