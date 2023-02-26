# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

SRC_URI="https://gitlab.com/OpenRGBDevelopers/OpenRGBSkinPlugin/-/archive/release_${PV}/OpenRGBSkinPlugin-release_${PV}.tar.bz2"
S="${WORKDIR}/OpenRGBSkinPlugin-release_${PV}"
KEYWORDS="amd64"

DESCRIPTION="Plugin for OpenRGB that allows you to customize the look and feel of OpenRGB"
HOMEPAGE="https://gitlab.com/OpenRGBDevelopers/OpenRGBSkinPlugin"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=app-misc/openrgb-0.8:=
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
}

src_configure() {
	eqmake5 \
		INCLUDEPATH+="${ESYSROOT}/usr/include/nlohmann"
}

src_install() {
	exeinto /usr/$(get_libdir)/OpenRGB/plugins
	doexe libOpenRGBSkinPlugin.so.1.0.0
}
