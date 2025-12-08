# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Plugin for OpenRGB to create virtual devices out of multiple real ones"
HOMEPAGE="https://gitlab.com/OpenRGBDevelopers/OpenRGBVisualMapPlugin"

MY_PV=$(ver_rs 2 "")
SRC_URI="https://gitlab.com/OpenRGBDevelopers/OpenRGBVisualMapPlugin/-/archive/release_candidate_${MY_PV}/OpenRGBVisualMapPlugin-release_candidate_${MY_PV}.tar.bz2"
S="${WORKDIR}/OpenRGBVisualMapPlugin-release_candidate_${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=app-misc/openrgb-0.9_p20250802:=
	dev-qt/qtbase:6[gui,widgets]
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
"

PATCHES=(
	"${FILESDIR}/openrgb-plugin-visualmap-0.9_p20250723-dep.patch"
	"${FILESDIR}/openrgb-plugin-visualmap-0.9_p20250723-build-system.patch"
)

src_prepare() {
	default
	rm -r OpenRGB || die
	ln -s "${ESYSROOT}/usr/include/OpenRGB" . || die
	sed -e '/^GIT_/d' -i *.pro || die

	# Because of -Wl,--export-dynamic in app-misc/openrgb, this resources.qrc
	# conflicts with the openrgb's one. So rename it.
	sed -e 's/resources.qrc/resources_visualmap_plugin.qrc/' -i *.pro || die
	mv --no-clobber resources.qrc resources_visualmap_plugin.qrc || die
}

src_configure() {
	eqmake6 INCLUDEPATH+="${ESYSROOT}/usr/include/nlohmann"
}

src_install() {
	exeinto /usr/$(get_libdir)/openrgb/plugins
	doexe libOpenRGBVisualMapPlugin.so
}
