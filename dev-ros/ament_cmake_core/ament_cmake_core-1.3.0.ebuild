# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit cmake python-any-r1

ROS_PN="ament_cmake"
if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ament/ament_cmake"
	S=${WORKDIR}/${P}/${PN}
else
	SRC_URI="https://github.com/ament/ament_cmake/archive/${PV}.tar.gz -> ${ROS_PN}-${PV}.tar.gz"
	S="${WORKDIR}/${ROS_PN}-${PV}/${PN}"
fi

DESCRIPTION="The core of the ament buildsystem in CMake"
HOMEPAGE="https://github.com/ament/ament_cmake"

LICENSE="Apache-2.0"
SLOT="0"
if [ "${PV#9999}" != "${PV}" ] ; then
	PROPERTIES="live"
else
	KEYWORDS="~amd64"
fi

RDEPEND="
	dev-python/ament_package
	dev-python/catkin_pkg
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/ament_package[${PYTHON_USEDEP}]
		dev-python/catkin_pkg[${PYTHON_USEDEP}]')
"

python_check_deps() {
	python_has_version "dev-python/ament_package[${PYTHON_USEDEP}]" \
		"dev-python/catkin_pkg[${PYTHON_USEDEP}]"
}
