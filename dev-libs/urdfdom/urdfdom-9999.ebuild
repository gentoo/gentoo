# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/urdfdom/urdfdom-9999.ebuild,v 1.1 2015/04/14 12:37:32 aballier Exp $

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros/urdfdom"
fi

PYTHON_COMPAT=( python2_7 )

inherit ${SCM} distutils-r1 cmake-utils

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://github.com/ros/urdfdom/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="URDF (U-Robot Description Format) library"
HOMEPAGE="http://ros.org/wiki/urdf"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/urdfdom_headers
	dev-libs/console_bridge
	dev-libs/boost:=[threads]"
DEPEND="${RDEPEND}"

PY_S="${S}/urdf_parser_py"

src_prepare() {
	sed -i -e 's/set(CMAKE_INSTALL_LIBDIR/#/' CMakeLists.txt || die
	cmake-utils_src_prepare
	cd "${PY_S}"
	S="${PY_S}" distutils-r1_src_prepare
}

src_configure() {
	local mycmakeargs=( "-DPYTHON=FALSE" )
	cmake-utils_src_configure
	cd "${PY_S}"
	S="${PY_S}" distutils-r1_src_configure
}

src_compile() {
	cmake-utils_src_compile
	cd "${PY_S}"
	S="${PY_S}" distutils-r1_src_compile
}

src_test() {
	cmake-utils_src_test
	cd "${PY_S}"
	S="${PY_S}" distutils-r1_src_test
}

src_install() {
	cmake-utils_src_install
	cd "${PY_S}"
	S="${PY_S}" distutils-r1_src_install
}
