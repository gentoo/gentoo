# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-controls/ros_control"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="RQT control manager plugin"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/controller_manager[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}"
