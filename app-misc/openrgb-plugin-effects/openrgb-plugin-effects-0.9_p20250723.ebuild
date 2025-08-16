# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic qmake-utils

DESCRIPTION="Plugin for OpenRGB with various Effects that can be synced across devices"
HOMEPAGE="https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin"

MY_COMMIT="ee3690437020c19ccd73dd42bea193a8c0709752"
MY_NOISE_COMMIT="97e62c5b5e26c8edabdc29a6b0a277192be3746c"
MY_QCODEEDITOR_COMMIT="a9aab24c7970a38d14bc79939306d9d3ba78cf61"
SRC_URI="
	https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin/-/archive/${MY_COMMIT}/OpenRGBEffectsPlugin-${MY_COMMIT}.tar.bz2 -> ${P}.tar.bz2
	https://github.com/SRombauts/SimplexNoise/archive/${MY_NOISE_COMMIT}.tar.gz -> SimplexNoise-2019-12-03.tar.gz
	https://github.com/justxi/QCodeEditor/archive/${MY_QCODEEDITOR_COMMIT}.tar.gz -> QCodeEditor-2021-08-17.tar.gz
"
S="${WORKDIR}/OpenRGBEffectsPlugin-${MY_COMMIT}"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-misc/openrgb-0.9_p20250802:=
	dev-libs/hidapi
	dev-qt/qtbase:6[gui,opengl,widgets,-gles2-only]
	dev-qt/qt5compat:6
	media-libs/libglvnd
	media-libs/openal
	media-video/pipewire:=
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
"

PATCHES=(
	"${FILESDIR}/${P}-dep.patch"
	"${FILESDIR}/${P}-build-system.patch"
)

src_prepare() {
	default

	filter-lto # Bug 927749

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
	eqmake6 INCLUDEPATH+="${ESYSROOT}/usr/include/nlohmann" \
		INCLUDEPATH+="${ESYSROOT}/usr/include/OpenRGB/SPDAccessor" \
		INCLUDEPATH+="${ESYSROOT}/usr/include/OpenRGB/hidapi_wrapper" \
		CONFIG+=link_pkgconfig \
		PKGCONFIG+=hidapi-hidraw
}

src_install() {
	exeinto /usr/$(get_libdir)/openrgb/plugins
	doexe libOpenRGBEffectsPlugin.so
}
