# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}
PYTHON_COMPAT=( python{2_7,3_6} pypy3 )

inherit ros-catkin

DESCRIPTION="Command-line tool for getting and setting ROS Parameters on the parameter server"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosgraph[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/yaml.patch" "${FILESDIR}/yaml2.patch" )
