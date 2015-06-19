# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtwayland/qtwayland-5.4.2.ebuild,v 1.1 2015/06/17 15:23:52 pesa Exp $

EAPI=5
inherit qt5-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86"
fi

IUSE="egl qml wayland-compositor xcomposite"

DEPEND="
	>=dev-libs/wayland-1.3.0
	>=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtgui-${PV}:5[egl=]
	media-libs/mesa[egl?]
	>=x11-libs/libxkbcommon-0.2.0
	qml? ( >=dev-qt/qtdeclarative-${PV}:5 )
	xcomposite? (
		x11-libs/libX11
		x11-libs/libXcomposite
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	if use wayland-compositor; then
		echo "CONFIG += wayland-compositor" >> "${QT5_BUILD_DIR}"/.qmake.cache
	fi

	qt_use_compile_test xcomposite

	qt5-build_src_configure
}
