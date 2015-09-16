# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="http://github.com/ros-infrastructure/catkin_pkg"
fi

inherit ${SCM} distutils-r1

DESCRIPTION="Standalone Python library for the catkin package system"
HOMEPAGE="http://wiki.ros.org/catkin_pkg"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="
		http://download.ros.org/downloads/${PN}/${P}.tar.gz
		http://github.com/ros-infrastructure/catkin_pkg/archive/${PV}.tar.gz -> ${P}.tar.gz
		"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] dev-python/nose[${PYTHON_USEDEP}] )
"
PATCHES=( "${FILESDIR}/catkin_prefix.patch" )

python_test() {
	nosetests -s --tests test || die
}

python_install_all() {
	distutils-r1_python_install_all
	# Avoid recursing in the whole hierarchy
	dodir /usr/
	touch "${ED}/usr/CATKIN_IGNORE"
}
