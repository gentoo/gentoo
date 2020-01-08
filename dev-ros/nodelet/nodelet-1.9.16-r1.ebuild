# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/nodelet_core"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"
PYTHON_COMPAT=( python{2_7,3_6} pypy3 )

inherit ros-catkin

DESCRIPTION="Provides a way to run multiple algorithms in the same process with zero copy transport"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/bondcpp
	dev-ros/cmake_modules
	dev-ros/pluginlib
		dev-libs/tinyxml2:=
	dev-ros/rosconsole
		dev-libs/console_bridge:=
	dev-ros/roscpp
	dev-libs/boost:=
	sys-apps/util-linux
	dev-ros/class_loader:=
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
