# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI=${EGIT_REPO_URI:-"https://gitlab.com/CalcProgrammer1/OpenRGB"}
else
	SRC_URI="https://gitlab.com/CalcProgrammer1/OpenRGB/-/archive/release_${PV}/OpenRGB-release_${PV}.tar.bz2"
	S="${WORKDIR}/OpenRGB-release_${PV}"
	KEYWORDS="~amd64 ~x86"
	PATCHES=(
		"${FILESDIR}"/OpenRGB-0.5-build-system.patch
	)
fi

DESCRIPTION="Open source RGB lighting control that doesn't depend on manufacturer software"
HOMEPAGE="https://openrgb.org https://gitlab.com/CalcProgrammer1/OpenRGB/"
LICENSE="GPL-2"
SLOT="0/1"

RDEPEND="
	dev-libs/hidapi:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	virtual/libusb:1
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES+=(
	"${FILESDIR}"/OpenRGB-0.6-pkgconf.patch
	"${FILESDIR}"/OpenRGB-0.6-plugins.patch
)

src_prepare() {
	default
	rm -r dependencies/{hidapi,libusb,json}* || die
}

src_configure() {
	# Some plugins require symbols defined in the main binary.
	# The official build system bundles OpenRGB as a submodule instead, and
	# compiles the .cpp file again.
	append-ldflags -Wl,--export-dynamic

	eqmake5 \
		INCLUDEPATH+="${ESYSROOT}/usr/include/nlohmann" \
		DEFINES+="GENTOO_PLUGINS_DIR=\\\\\"\\\"${EPREFIX}/usr/$(get_libdir)/OpenRGB/plugins\\\\\"\\\""
}

src_install() {
	emake INSTALL_ROOT="${ED}" install

	dodoc README.md OpenRGB.patch

	# This is for plugins. Upstream doesn't install any headers at all.
	insinto /usr/include/OpenRGB
	doins *.h
	insinto /usr/include/OpenRGB/RGBController
	doins RGBController/*.h
	insinto /usr/include/OpenRGB/i2c_smbus
	doins i2c_smbus/*.h
	insinto /usr/include/OpenRGB/net_port
	doins net_port/*.h
}
