# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

inherit cmake-utils python-r1

ROS_PN="ament_cmake"
DESCRIPTION="The core of the ament buildsystem in CMake"
HOMEPAGE="https://github.com/ament/ament_cmake"
SRC_URI="https://github.com/ament/ament_cmake/archive/${PV}.tar.gz -> ${ROS_PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-ros/ament_cmake_core[${PYTHON_USEDEP}]
	dev-ros/ament_cmake_libraries[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="${PYTHON_DEPS}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
S="${WORKDIR}/${ROS_PN}-${PV}/${PN}"

src_configure() {
	# This is a build tool that does not install python-related files
	# ... but we need to propagate the deps and use python3 to build it.
	local pyimpl="${PYTHON_COMPAT[0]}"
	python_export "${pyimpl}" EPYTHON PYTHON
	python_wrapper_setup
	cmake-utils_src_configure
}
