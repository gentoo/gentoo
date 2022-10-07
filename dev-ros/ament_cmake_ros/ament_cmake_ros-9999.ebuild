# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit cmake python-any-r1

ROS_PN="ament_cmake_ros"
if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ros2/ament_cmake_ros"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://github.com/ros2/ament_cmake_ros/archive/${PV}.tar.gz -> ${ROS_PN}-${PV}.tar.gz"
	S="${WORKDIR}/${ROS_PN}-${PV}/${PN}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="ROS specific CMake bits in the ament buildsystem"
HOMEPAGE="https://github.com/ros2/ament_cmake_ros"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	$(python_gen_any_dep 'ros-meta/ament_cmake[${PYTHON_USEDEP}]')
	test? (
		dev-ros/ament_lint_auto
	)
	${PYTHON_DEPS}
"

python_check_deps() {
	python_has_version "ros-meta/ament_cmake[${PYTHON_USEDEP}]"
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
	)
	cmake_src_configure
}
