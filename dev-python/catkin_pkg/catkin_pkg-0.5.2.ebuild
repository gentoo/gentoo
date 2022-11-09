# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros-infrastructure/catkin_pkg"
fi

inherit ${SCM} distutils-r1

DESCRIPTION="Standalone Python library for the catkin package system"
HOMEPAGE="https://wiki.ros.org/catkin_pkg"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
else
	SRC_URI="https://github.com/ros-infrastructure/catkin_pkg/archive/${PV}.tar.gz -> ${P}-gh.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	!<dev-util/catkin-0.7.14"
BDEPEND="
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/catkin_prefix2.patch"
	"${FILESDIR}/ros_packages.patch"
	"${FILESDIR}/infinite_loop5.patch"
)

distutils_enable_tests nose
