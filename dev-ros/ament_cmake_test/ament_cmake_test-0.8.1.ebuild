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

DESCRIPTION="The ability to add tests in the ament buildsystem"
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
		dev-python/ament_package[${PYTHON_USEDEP}]
		dev-python/catkin_pkg[${PYTHON_USEDEP}]
	dev-ros/ament_cmake_python
	${PYTHON_DEPS}
"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_configure() {
	python_foreach_impl cmake-utils_src_configure
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	python_foreach_impl cmake-utils_src_test
}

src_install() {
	python_foreach_impl cmake-utils_src_install
	python_foreach_impl python_optimize
}
