# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy{,3} )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros-infrastructure/catkin_pkg"
fi

inherit ${SCM} distutils-r1

DESCRIPTION="Standalone Python library for the catkin package system"
HOMEPAGE="http://wiki.ros.org/catkin_pkg"
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

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] dev-python/nose[${PYTHON_USEDEP}] )
"
PATCHES=(
	"${FILESDIR}/catkin_prefix.patch"
	"${FILESDIR}/argparse.patch"
	"${FILESDIR}/ros_packages.patch"
	"${FILESDIR}/infinite_loop.patch"
)

python_test() {
	nosetests -s --tests test || die
}
