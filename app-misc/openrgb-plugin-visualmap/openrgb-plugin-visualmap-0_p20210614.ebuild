# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

MY_GIT_COMMIT="b603bb994719c765cc52c116c6f9f3983fc2a7b2"
SRC_URI="https://gitlab.com/OpenRGBDevelopers/OpenRGBVisualMapPlugin/-/archive/${MY_GIT_COMMIT}/OpenRGBVisualMapPlugin-${MY_GIT_COMMIT}.tar.bz2"
S="${WORKDIR}/OpenRGBVisualMapPlugin-${MY_GIT_COMMIT}"
KEYWORDS="~amd64"

DESCRIPTION="Plugin for OpenRGB to create virtual devices out of multiple real ones"
HOMEPAGE="https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=app-misc/openrgb-0.6-r1:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
"

src_prepare() {
	default
	rm -r OpenRGB || die
	sed -i -e '/RGBController.cpp/d' OpenRGBVisualMapPlugin.pro || die
}

src_configure() {
	eqmake5 \
		INCLUDEPATH+="${ESYSROOT}/usr/include/nlohmann" \
		INCLUDEPATH+="${ESYSROOT}/usr/include/OpenRGB" \
		INCLUDEPATH+="${ESYSROOT}/usr/include/OpenRGB/RGBController" \
		INCLUDEPATH+="${ESYSROOT}/usr/include/OpenRGB/i2c_smbus" \
		INCLUDEPATH+="${ESYSROOT}/usr/include/OpenRGB/net_port"
}

src_install() {
	exeinto /usr/$(get_libdir)/OpenRGB/plugins
	doexe libOpenRGBVisualMapPlugin.so.1.0.0
}
