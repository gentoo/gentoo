# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-controls/ros_control"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Tests for the controller manager"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/controller_manager[${PYTHON_USEDEP}]
	dev-ros/controller_interface
	dev-ros/control_toolbox
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/rostest[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-ros/rosservice[${PYTHON_USEDEP}]
	)"
