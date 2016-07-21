# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="The OpenVG module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="amd64 arm ~ia64 ppc ~ppc64 x86 ~x86-fbsd"
fi

IUSE="qt3support"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[aqua=,debug=,egl,qt3support=,${MULTILIB_USEDEP}]
	media-libs/mesa[egl,openvg,${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/openvg
	src/plugins/graphicssystems/openvg"

QCONFIG_ADD="openvg"
QCONFIG_DEFINE="QT_OPENVG"

multilib_src_configure() {
	local myconf=(
		-openvg -egl
		$(qt_use qt3support)
	)
	qt4_multilib_src_configure
}

multilib_src_install_all() {
	qt4_multilib_src_install_all

	dodir /usr/share/qt4/graphicssystems
	echo "experimental" > "${ED}"/usr/share/qt4/graphicssystems/openvg || die
}
