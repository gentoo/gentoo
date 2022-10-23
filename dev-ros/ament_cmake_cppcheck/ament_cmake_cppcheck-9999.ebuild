# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit cmake python-any-r1

ROS_PN="ament_lint"
if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ament/ament_lint"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://github.com/ament/ament_lint/archive/${PV}.tar.gz -> ${ROS_PN}-${PV}.tar.gz"
	S="${WORKDIR}/${ROS_PN}-${PV}/${PN}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="CMake API for ament_cppcheck to perform static code analysis on C/C++"
HOMEPAGE="https://github.com/ament/ament_lint"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ros/ament_cmake_test
	dev-ros/ament_cmake_core
	dev-ros/ament_cppcheck
"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/ament_package[${PYTHON_USEDEP}]
		dev-python/catkin_pkg[${PYTHON_USEDEP}]')
	dev-ros/ament_cmake_test
	dev-ros/ament_cmake_core
	test? (
		dev-ros/ament_cmake_copyright
		$(python_gen_any_dep 'dev-ros/ament_copyright[${PYTHON_USEDEP}]')
		dev-ros/ament_cmake_lint_cmake
	)
	${PYTHON_DEPS}
"

python_check_deps() {
	{ use !test || python_has_version "dev-ros/ament_copyright[${PYTHON_USEDEP}]"; } && \
		python_has_version "dev-python/catkin_pkg[${PYTHON_USEDEP}]" \
			"dev-python/ament_package[${PYTHON_USEDEP}]"
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
	)
	cmake_src_configure
}
