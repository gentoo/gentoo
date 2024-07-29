# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs flag-o-matic qmake-utils udev xdg-utils

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI=${EGIT_REPO_URI:-"https://gitlab.com/CalcProgrammer1/OpenRGB"}
else
	SRC_URI="https://gitlab.com/CalcProgrammer1/OpenRGB/-/archive/release_${PV}/OpenRGB-release_${PV}.tar.bz2"
	S="${WORKDIR}/OpenRGB-release_${PV}"
	KEYWORDS="amd64 ~loong ~x86"
	PATCHES=( "${FILESDIR}"/OpenRGB-0.9-build-system.patch )
fi

DESCRIPTION="Open source RGB lighting control"
HOMEPAGE="https://openrgb.org https://gitlab.com/CalcProgrammer1/OpenRGB/"
LICENSE="GPL-2"
# subslot is OPENRGB_PLUGIN_API_VERSION from
# https://gitlab.com/CalcProgrammer1/OpenRGB/-/blob/master/OpenRGBPluginInterface.h
SLOT="0/3"

RDEPEND="
	dev-cpp/cpp-httplib:=
	dev-libs/hidapi
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	net-libs/mbedtls:=
	virtual/libusb:1
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
	dev-libs/mdns
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES+=(
	"${FILESDIR}"/OpenRGB-0.7-r1-udev.patch
	"${FILESDIR}"/OpenRGB-0.9-udev-check.patch
)

CHECKREQS_DISK_BUILD="2G"

src_prepare() {
	default
	rm -r dependencies/{httplib,hidapi,libusb,mdns,json,mbedtls}* \
		|| die "Failed to remove unneded deps"
}

src_configure() {
	# Some plugins require symbols defined in the main binary.
	# The upstream build system of plugins bundles OpenRGB as a submodule
	# instead, and compiles the .cpp file again.
	append-ldflags -Wl,--export-dynamic

	# > warning: ‘-pipe’ ignored because ‘-save-temps’ specified
	filter-flags -pipe

	# cpp-httplib >=0.16.0 changed the library name from "httplib" to "cpp-httplib".
	# See bug: https://bugs.gentoo.org/934576
	local -a libs=()
	if has_version "<dev-cpp/cpp-httplib-0.16.0" ; then
		libs+=( -lhttplib )
	else
		libs+=( -lcpp-httplib )
	fi

	eqmake5 \
		INCLUDEPATH+="${ESYSROOT}/usr/include/nlohmann" \
		DEFINES+="OPENRGB_EXTRA_PLUGIN_DIRECTORY=\\\\\"\\\"${EPREFIX}/usr/$(get_libdir)/OpenRGB/plugins\\\\\"\\\"" \
		LIBS+="${libs[@]}"
}

src_install() {
	emake INSTALL_ROOT="${ED}" install

	dodoc README.md OpenRGB.patch

	rm -r "${ED}"/usr/lib/udev/ || die
	udev_dorules 60-openrgb.rules

	# This is for plugins. Upstream doesn't install any headers at all.
	insinto /usr/include/OpenRGB
	find . -name '*.h' -exec cp --parents '{}' "${ED}/usr/include/OpenRGB/" ';' || die
}

pkg_postinst() {
	xdg_icon_cache_update
	udev_reload
}

pkg_postrm() {
	xdg_icon_cache_update
	udev_reload
}
