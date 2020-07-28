# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}

inherit ros-catkin

DESCRIPTION="ROS Master implementation"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosgraph[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/defusedxml[\${PYTHON_USEDEP}]")
"
DEPEND="${RDEPEND}
	test? ( $(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]") )"
