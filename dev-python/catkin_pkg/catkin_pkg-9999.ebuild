# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7,3_8,3_9} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend

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
	KEYWORDS=""
else
	SRC_URI="https://github.com/ros-infrastructure/catkin_pkg/archive/${PV}.tar.gz -> ${P}-gh.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND} ${BDEPEND}
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"
RDEPEND="${RDEPEND}
	!<dev-util/catkin-0.7.14"
PATCHES=(
	"${FILESDIR}/catkin_prefix2.patch"
	"${FILESDIR}/ros_packages.patch"
	"${FILESDIR}/infinite_loop4.patch"
	"${FILESDIR}/summary_single_line.patch"
)

python_test() {
	nosetests -s --tests test || die
}
