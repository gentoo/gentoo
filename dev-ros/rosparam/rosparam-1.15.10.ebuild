# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}

inherit ros-catkin

DESCRIPTION="Command-line tool for getting and setting ROS Parameters on the parameter server"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosgraph[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/pyyaml[\${PYTHON_USEDEP}]")
"
DEPEND="${RDEPEND}"
