# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="The OpenGL module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS="alpha arm hppa ia64 ppc ppc64 sparc"
else
	KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
fi

IUSE="egl qt3support"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[aqua=,debug=,egl=,qt3support=,${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.5.0-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXrender-0.9.7-r1[${MULTILIB_USEDEP}]
	>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/opengl
	src/plugins/graphicssystems/opengl"

QCONFIG_ADD="opengl"
QCONFIG_DEFINE="QT_OPENGL"

multilib_src_configure() {
	local myconf=(
		-opengl
		$(qt_use qt3support)
		$(qt_use egl)
	)
	qt4_multilib_src_configure
}

multilib_src_install_all() {
	qt4_multilib_src_install_all

	dodir /usr/share/qt4/graphicssystems
	echo "experimental" > "${ED}"/usr/share/qt4/graphicssystems/opengl || die
}
