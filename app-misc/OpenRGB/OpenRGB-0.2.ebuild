# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

MY_P="${PN}-release_${PV}"
COMMIT_HASH="13414ec9b84c299631e5100744f2b83923cba3c8"

DESCRIPTION="Open source RGB lighting control that doesn't depend on manufacturer software"
HOMEPAGE="https://gitlab.com/CalcProgrammer1/OpenRGB/"
SRC_URI="https://gitlab.com/CalcProgrammer1/OpenRGB/-/archive/release_0.2/${P}.tar.bz2"
S="${WORKDIR}/${MY_P}-${COMMIT_HASH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/hidapi:=
	dev-libs/libbsd:=
	dev-qt/qtcore:5=
	dev-qt/qtgui:5=
	dev-qt/qtwidgets:5=
	virtual/libusb:1
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/OpenRGB-0.2-build-system.patch"
	"${FILESDIR}/OpenRGB-0.2-use-system-hidapi.patch"
	"${FILESDIR}/OpenRGB-0.2-install.patch"
)

src_prepare() {
	default
	rm -rf dependencies/{hidapi,libusb}* || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	dodoc README.md

	make_desktop_entry ${PN} ${PN} ${PN} 'System;Monitor;HardwareSettings;'
}
