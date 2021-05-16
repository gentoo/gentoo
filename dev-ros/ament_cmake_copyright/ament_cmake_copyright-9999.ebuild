# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_7,3_8} )

inherit cmake python-any-r1

ROS_PN="ament_lint"
if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ament/ament_lint"
	SRC_URI=""
	S=${WORKDIR}/${P}/${PN}
else
	SRC_URI="https://github.com/ament/ament_lint/archive/${PV}.tar.gz -> ${ROS_PN}-${PV}.tar.gz"
	S="${WORKDIR}/${ROS_PN}-${PV}/${PN}"
fi

DESCRIPTION="The auto-magic functions for ease to use of the ament linters"
HOMEPAGE="https://github.com/ament/ament_lint"

LICENSE="Apache-2.0"
SLOT="0"
if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ros/ament_copyright
	dev-ros/ament_cmake_test
"
DEPEND=""
# Deps here are transitive from ament_cmake_core to have matching python support
BDEPEND="
	$(python_gen_any_dep 'dev-python/ament_package[${PYTHON_USEDEP}] dev-python/catkin_pkg[${PYTHON_USEDEP}] dev-ros/ament_copyright[${PYTHON_USEDEP}] test? ( dev-ros/ament_lint_cmake[${PYTHON_USEDEP}] )' )
	dev-ros/ament_cmake_core
	dev-ros/ament_cmake_test
	dev-ros/ament_copyright
	test? (
		dev-ros/ament_cmake_lint_cmake
	)
	${PYTHON_DEPS}
"

python_check_deps() {
	has_version "dev-python/ament_package[${PYTHON_USEDEP}]" && \
		has_version "dev-python/catkin_pkg[${PYTHON_USEDEP}]" && \
		has_version "dev-ros/ament_copyright[${PYTHON_USEDEP}]" && \
		( use !test || has_version "dev-ros/ament_lint_cmake[${PYTHON_USEDEP}]" )
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
	)
	cmake_src_configure
}
