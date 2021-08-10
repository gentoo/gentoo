# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

MY_GIT_COMMIT="3d937cf5112a98052f98a106dc0f5de1eafc20ea"
SRC_URI="https://gitlab.com/OpenRGBDevelopers/openrgbskinplugin/-/archive/${MY_GIT_COMMIT}/openrgbskinplugin-${MY_GIT_COMMIT}.tar.bz2"
S="${WORKDIR}/openrgbskinplugin-${MY_GIT_COMMIT}"
KEYWORDS="~amd64"

DESCRIPTION="Plugin for OpenRGB that allows you to customize the look and feel of OpenRGB"
HOMEPAGE="https://gitlab.com/OpenRGBDevelopers/openrgbskinplugin"
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
	doexe libOpenRGBSkinPlugin.so.1.0.0
}
