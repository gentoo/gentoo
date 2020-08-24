# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit cmake python-any-r1

ROS_PN="python_cmake_module"
if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ros2/python_cmake_module"
	SRC_URI=""
	S=${WORKDIR}/${P}
else
	SRC_URI="https://github.com/ros2/python_cmake_module/archive/${PV}.tar.gz -> ${ROS_PN}-${PV}.tar.gz"
	S="${WORKDIR}/${ROS_PN}-${PV}"
fi

DESCRIPTION="CMake module with extra functionality for Python"
HOMEPAGE="https://github.com/ros2/python_cmake_module"

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
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_any_dep 'ros-meta/ament_cmake[${PYTHON_USEDEP}]')
	test? (
		dev-ros/ament_lint_auto
	)
	${PYTHON_DEPS}
"

python_check_deps() {
	has_version "ros-meta/ament_cmake[${PYTHON_USEDEP}]"
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
	)
	cmake_src_configure
}
