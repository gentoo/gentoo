# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=core/${PN}

inherit ros-catkin

DESCRIPTION="Base dependencies and support libraries for ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep ">=dev-python/rospkg-1.0.37[\${PYTHON_USEDEP}]")
	dev-libs/boost:=
	dev-ros/rospack
	dev-ros/ros_environment
"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
	)"

src_test() {
	export ROS_PACKAGE_PATH="${S}/../../"
	ros-catkin_src_test
}
