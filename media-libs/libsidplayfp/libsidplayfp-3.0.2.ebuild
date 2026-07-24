# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library for the sidplay2 fork with resid-fp"
HOMEPAGE="https://github.com/libsidplayfp/libsidplayfp"
SRC_URI="https://github.com/libsidplayfp/libsidplayfp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/7"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE="test usb"
RESTRICT="!test? ( test )"

RDEPEND="
	>=media-libs/libresidfp-1.0.2:=
	usb? ( >=virtual/libusb-1-r2:1 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local myeconfargs=(
		# Avoid automagic media-libs/resid dep, can wire up if requested
		--without-exsid
		$(use_with usb usbsid)
		$(use_enable test tests)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
