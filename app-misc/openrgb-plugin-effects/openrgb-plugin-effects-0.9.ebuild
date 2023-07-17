# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Plugin for OpenRGB with various Effects that can be synced across devices"
HOMEPAGE="https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin"

MY_NOISE_COMMIT="97e62c5b5e26c8edabdc29a6b0a277192be3746c"
MY_QCODEEDITOR_COMMIT="a9aab24c7970a38d14bc79939306d9d3ba78cf61"
SRC_URI="
	https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin/-/archive/release_${PV}/OpenRGBEffectsPlugin-release_${PV}.tar.bz2
	https://github.com/SRombauts/SimplexNoise/archive/${MY_NOISE_COMMIT}.tar.gz -> SimplexNoise-2019-12-03.tar.gz
	https://github.com/justxi/QCodeEditor/archive/${MY_QCODEEDITOR_COMMIT}.tar.gz -> QCodeEditor-2021-08-17.tar.gz
"
S="${WORKDIR}/OpenRGBEffectsPlugin-release_${PV}"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-misc/openrgb-0.9:=
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
	"${FILESDIR}/openrgb-plugin-effects-0.9-dep.patch"
)

src_prepare() {
	default
	rm -r OpenRGB || die
	ln -s "${ESYSROOT}/usr/include/OpenRGB" . || die
	sed -e '/^GIT_/d' -i *.pro || die

	rmdir Dependencies/SimplexNoise || die
	ln -s "${WORKDIR}/SimplexNoise-${MY_NOISE_COMMIT}" Dependencies/SimplexNoise || die

	rmdir Dependencies/QCodeEditor || die
	ln -s "${WORKDIR}/QCodeEditor-${MY_QCODEEDITOR_COMMIT}" Dependencies/QCodeEditor || die

	# Because of -Wl,--export-dynamic in app-misc/openrgb, this resources.qrc
	# conflicts with the openrgb's one. So rename it.
	sed -e 's/ resources.qrc/ resources_effects_plugin.qrc/' -i *.pro || die
	mv --no-clobber resources.qrc resources_effects_plugin.qrc || die
}

src_configure() {
	eqmake5 \
		INCLUDEPATH+="${ESYSROOT}/usr/include/nlohmann"
}

src_install() {
	exeinto /usr/$(get_libdir)/OpenRGB/plugins
	doexe libOpenRGBEffectsPlugin.so.1.0.0
}
