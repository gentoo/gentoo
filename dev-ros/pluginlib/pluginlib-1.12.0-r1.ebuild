# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/pluginlib"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR="${PN}"

inherit ros-catkin

DESCRIPTION="Provides tools for writing and dynamically loading plugins using the ROS build infrastructure"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-ros/class_loader-0.3.5:=
	dev-ros/rosconsole
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-libs/boost:=
	dev-libs/tinyxml2:=
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
PATCHES=( "${FILESDIR}/catkin_prefix_path2.patch" )
