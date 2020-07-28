# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-visualization/visualization_tutorials"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Tutorials showing how to call into rviz internals from python scripts"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/rviz[${PYTHON_SINGLE_USEDEP}]"
DEPEND="${RDEPEND}"
