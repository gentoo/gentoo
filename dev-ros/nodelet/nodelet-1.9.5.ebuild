# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/nodelet_core"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit ros-catkin

DESCRIPTION="Provides a way to run multiple algorithms in the same process with zero copy transport"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/bondcpp
	dev-ros/cmake_modules
	dev-ros/pluginlib
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-libs/boost:=
	sys-apps/util-linux
"
DEPEND="${RDEPEND}"
