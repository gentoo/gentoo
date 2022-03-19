# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Command-line tool for installing ROS system dependencies"
HOMEPAGE="https://wiki.ros.org/rosdep"

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/ros-infrastructure/rosdep"
	inherit git-r3
else
	SRC_URI="http://download.ros.org/downloads/${PN}/${P}.tar.gz
		https://github.com/ros-infrastructure/rosdep/archive/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"

# Tests need network
RESTRICT="test"
PROPERTIES="test_network"

RDEPEND="
	dev-python/catkin_pkg[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]
	dev-python/rosdistro[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
	)
"
PATCHES=( "${FILESDIR}/tests.patch" )

distutils_enable_tests pytest

src_test() {
	unset ROS_DISTRO
	distutils-r1_src_test
}

pkg_postrm() {
	if [ "${ROOT:-/}" = "/" ] ; then
		einfo "Removing rosdep default sources list."
		rm -f "${EPREFIX}/etc/ros/rosdep/sources.list.d/20-default.list"
	fi
}

pkg_postinst() {
	if [ "${ROOT:-/}" = "/" -a ! -f "${EPREFIX}/etc/ros/rosdep/sources.list.d/20-default.list" ] ; then
		einfo "Initializing rosdep"
		rosdep init
	fi
}
