# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

inherit cmake-utils python-r1

ROS_PN="ament_cmake"
if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ament/ament_cmake"
	SRC_URI=""
	S=${WORKDIR}/${P}/${PN}
else
	SRC_URI="https://github.com/ament/ament_cmake/archive/${PV}.tar.gz -> ${ROS_PN}-${PV}.tar.gz"
	S="${WORKDIR}/${ROS_PN}-${PV}/${PN}"
fi

DESCRIPTION="The entry point package for the ament buildsystem"
HOMEPAGE="https://github.com/ament/ament_cmake"

LICENSE="Apache-2.0"
SLOT="0"
if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE=""

DEPEND="
	dev-ros/ament_cmake_core
	dev-ros/ament_cmake_export_definitions
	dev-ros/ament_cmake_export_dependencies
	dev-ros/ament_cmake_export_include_directories
	dev-ros/ament_cmake_export_interfaces
	dev-ros/ament_cmake_export_libraries
	dev-ros/ament_cmake_export_link_flags
	dev-ros/ament_cmake_libraries
	dev-ros/ament_cmake_python
	dev-ros/ament_cmake_target_dependencies
	dev-ros/ament_cmake_test[${PYTHON_USEDEP}]
	dev-ros/ament_cmake_version
	${PYTHON_DEPS}

	dev-python/ament_package[${PYTHON_USEDEP}]
	dev-python/catkin_pkg[${PYTHON_USEDEP}]
"
# Last batch of deps above are transitive (from ament_cmake_core) but we need this to propagate proper deps
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_configure() {
	# This is a build tool that does not install python-related files
	# ... but we need to propagate the deps and use python3 to build it.
	local pyimpl="${PYTHON_COMPAT[0]}"
	python_export "${pyimpl}" EPYTHON PYTHON
	python_wrapper_setup
	cmake-utils_src_configure
}
