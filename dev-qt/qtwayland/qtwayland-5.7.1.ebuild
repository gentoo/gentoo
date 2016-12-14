# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit qt5-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="egl wayland-compositor xcomposite"

DEPEND="
	>=dev-libs/wayland-1.4.0
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[egl=]
	media-libs/mesa[egl?]
	>=x11-libs/libxkbcommon-0.2.0
	wayland-compositor? ( ~dev-qt/qtdeclarative-${PV} )
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
