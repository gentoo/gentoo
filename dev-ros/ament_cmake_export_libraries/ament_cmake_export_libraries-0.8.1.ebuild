# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

inherit cmake-utils python-any-r1

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

DESCRIPTION="Export libraries to downstream packages in the ament buildsystem"
HOMEPAGE="https://github.com/ament/ament_cmake"

LICENSE="Apache-2.0"
SLOT="0"
if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE=""

RDEPEND="
	dev-ros/ament_cmake_core
"
DEPEND="${RDEPEND}"
# Deps here are transitive from ament_cmake_core to have matching python support
BDEPEND="
	$(python_gen_any_dep 'dev-python/ament_package[${PYTHON_USEDEP}] dev-python/catkin_pkg[${PYTHON_USEDEP}]')
	${PYTHON_DEPS}
"

python_check_deps() {
	has_version "dev-python/ament_package[${PYTHON_USEDEP}]" && \
		has_version "dev-python/catkin_pkg[${PYTHON_USEDEP}]"
}
