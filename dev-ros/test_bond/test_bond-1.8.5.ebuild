# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/bond_core"
KEYWORDS="~amd64 ~arm"
CATKIN_HAS_MESSAGES=yes
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Tests for bond, bondpy and bondcpp"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/bondcpp
	dev-ros/bondpy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
