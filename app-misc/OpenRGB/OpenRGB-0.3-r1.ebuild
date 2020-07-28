# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

MY_P="${PN}-release_${PV}"
COMMIT_HASH="308bb6f9b8169c8e1c5123f9499373509f140268"

DESCRIPTION="Open source RGB lighting control that doesn't depend on manufacturer software"
HOMEPAGE="https://gitlab.com/CalcProgrammer1/OpenRGB/"
SRC_URI="https://gitlab.com/CalcProgrammer1/OpenRGB/-/archive/release_${PV}/${P}.tar.bz2"
S="${WORKDIR}/${MY_P}-${COMMIT_HASH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="udev"

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

	dodoc README.md OpenRGB.patch

	if use udev; then
		insinto /lib/udev/rules.d
		doins 60-openrgb.rules
	fi
}
