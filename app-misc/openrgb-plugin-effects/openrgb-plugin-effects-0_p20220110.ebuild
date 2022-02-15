# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

MY_GIT_COMMIT="a7222bdbcd3c52e13d96993a33c5648f1306aeba"
SRC_URI="https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin/-/archive/${MY_GIT_COMMIT}/OpenRGBEffectsPlugin-${MY_GIT_COMMIT}.tar.bz2"
S="${WORKDIR}/OpenRGBEffectsPlugin-${MY_GIT_COMMIT}"
KEYWORDS="~amd64"

DESCRIPTION="Plugin for OpenRGB with various Effects that can be synced across devices"
HOMEPAGE="https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=app-misc/openrgb-0.7:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5[-gles2-only]
	dev-qt/qtwidgets:5[-gles2-only]
	media-libs/openal
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
"

PATCHES=(
	"${FILESDIR}/openrgb-plugin-effects-0_p20220110-dep.patch"
)

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
	doexe libOpenRGBEffectsPlugin.so.1.0
}
