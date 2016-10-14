# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/pluginlib"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit ros-catkin

DESCRIPTION="Provides tools for writing and dynamically loading plugins using the ROS build infrastructure"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-ros/class_loader-0.3.5
	dev-ros/rosconsole
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-libs/boost:=
	dev-libs/tinyxml
	dev-ros/cmake_modules
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
