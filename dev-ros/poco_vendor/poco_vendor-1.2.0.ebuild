# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

inherit cmake-utils python-r1

if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ros2/poco_vendor"
	SRC_URI=""
else
	SRC_URI="https://github.com/ros2/poco_vendor/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="CMake shim over the poco library"
HOMEPAGE="https://github.com/ros2/poco_vendor"

LICENSE="Apache-2.0 Boost-1.0"
SLOT="0"
if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE=""

DEPEND="
	dev-libs/poco
"
RDEPEND="${DEPEND}"
BDEPEND="ros-meta/ament_cmake[${PYTHON_USEDEP}]
	${PYTHON_DEPS}
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_configure() {
	# This is a build tool that does not install python-related files
	# ... but we need to propagate the deps and use python3 to build it.
	local pyimpl="${PYTHON_COMPAT[0]}"
	python_export "${pyimpl}" EPYTHON PYTHON
	python_wrapper_setup
	cmake-utils_src_configure
}
