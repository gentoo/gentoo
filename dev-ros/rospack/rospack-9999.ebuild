# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/rospack"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit ros-catkin

DESCRIPTION="Retrieves information about ROS packages available on the filesystem"

LICENSE="BSD"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-libs/boost:=
	dev-libs/tinyxml2:=
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	>=dev-ros/cmake_modules-0.4.1
	test? (
		dev-cpp/gtest
		dev-python/nose
	)"

PATCHES=(
	"${FILESDIR}/gentoo.patch"
	"${FILESDIR}/multipy.patch"
)

src_install() {
	ros-catkin_src_install
	# Assume greatest alphabetically is what we want as default implementation
	for i in "${ED}"/usr/$(get_libdir)/librospack*.so ; do
		dosym $(basename "${i}") /usr/$(get_libdir)/librospack.so
	done
}
