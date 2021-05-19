# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_7,3_8} )

inherit cmake python-any-r1

if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ros2/console_bridge_vendor"
	SRC_URI=""
else
	SRC_URI="https://github.com/ros2/console_bridge_vendor/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Wrapper around console_bridge"
HOMEPAGE="https://github.com/ros2/console_bridge_vendor"

LICENSE="Apache-2.0 BSD"
SLOT="0"
if [ "${PV#9999}" != "${PV}" ] ; then
	PROPERTIES="live"
else
	KEYWORDS="~amd64"
fi
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/console_bridge-1.0.1
"
RDEPEND="${DEPEND}"
BDEPEND="
	$(python_gen_any_dep 'ros-meta/ament_cmake[${PYTHON_USEDEP}]')
	test? ( dev-ros/ament_lint_auto )
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
