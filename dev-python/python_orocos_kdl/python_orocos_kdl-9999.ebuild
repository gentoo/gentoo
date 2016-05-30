# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/orocos/orocos_kinematics_dynamics"
fi

inherit ${SCM} python-r1 cmake-utils

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://github.com/orocos/orocos_kinematics_dynamics/archive/v${PV}.tar.gz -> orocos_kinematics_dynamics-${PV}.tar.gz"
fi

DESCRIPTION="Python bindings for KDL"
HOMEPAGE="http://www.orocos.org/kdl"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="
	sci-libs/orocos_kdl
	dev-python/sip[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

if [ "${PV#9999}" != "${PV}" ] ; then
	S=${WORKDIR}/${P}/python_orocos_kdl
else
	S=${WORKDIR}/orocos_kinematics_dynamics-${PV}/python_orocos_kdl
fi

src_configure() {
	python_foreach_impl cmake-utils_src_configure
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	python_foreach_impl cmake-utils_src_test
}

src_install() {
	python_foreach_impl cmake-utils_src_install
}
