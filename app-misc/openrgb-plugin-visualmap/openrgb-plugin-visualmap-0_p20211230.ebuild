# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

MY_GIT_COMMIT="223c5ec67d256c5fa3bf7f3d572213114d93db6e"
SRC_URI="https://gitlab.com/OpenRGBDevelopers/OpenRGBVisualMapPlugin/-/archive/${MY_GIT_COMMIT}/OpenRGBVisualMapPlugin-${MY_GIT_COMMIT}.tar.bz2"
S="${WORKDIR}/OpenRGBVisualMapPlugin-${MY_GIT_COMMIT}"
KEYWORDS="amd64"

DESCRIPTION="Plugin for OpenRGB to create virtual devices out of multiple real ones"
HOMEPAGE="https://gitlab.com/OpenRGBDevelopers/OpenRGBVisualMapPlugin"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=app-misc/openrgb-0.7:=
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
	ln -s "${ESYSROOT}/usr/include/OpenRGB" . || die
	sed -e '/^GIT_/d' -i *.pro || die
	sed -i -e '/RGBController.cpp/d' OpenRGBVisualMapPlugin.pro || die
}

src_configure() {
	eqmake5 \
		INCLUDEPATH+="${ESYSROOT}/usr/include/nlohmann"
}

src_install() {
	exeinto /usr/$(get_libdir)/OpenRGB/plugins
	doexe libOpenRGBVisualMapPlugin.so.1.0.0
}
