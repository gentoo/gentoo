# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit cmake python-any-r1

if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ros2/poco_vendor"
else
	SRC_URI="https://github.com/ros2/poco_vendor/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="CMake shim over the poco library"
HOMEPAGE="https://github.com/ros2/poco_vendor"

LICENSE="Apache-2.0 Boost-1.0"
SLOT="0"

DEPEND="
	>=dev-libs/poco-1.6.1
	dev-libs/libpcre
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
BDEPEND="
	$(python_gen_any_dep 'ros-meta/ament_cmake[${PYTHON_USEDEP}]')
	${PYTHON_DEPS}
"

python_check_deps() {
	python_has_version "ros-meta/ament_cmake[${PYTHON_USEDEP}]"
}
