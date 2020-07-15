# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/rospack"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Retrieves information about ROS packages available on the filesystem"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	>=dev-libs/tinyxml2-5:="
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-python/nose
	)"
RDEPEND="${RDEPEND}
	dev-ros/ros_environment"
BDEPEND=">=dev-ros/cmake_modules-0.4.1"

PATCHES=(
	"${FILESDIR}/gentoo.patch"
)
