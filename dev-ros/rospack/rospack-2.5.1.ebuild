# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/rospack"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Retrieves information about ROS packages available on the filesystem"

LICENSE="BSD"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-libs/boost:=
	>=dev-libs/tinyxml2-5:=
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	>=dev-ros/cmake_modules-0.4.1
	test? (
		dev-cpp/gtest
		dev-python/nose
	)"
RDEPEND="${RDEPEND}
	dev-ros/ros_environment"

PATCHES=(
	"${FILESDIR}/gentoo.patch"
)
