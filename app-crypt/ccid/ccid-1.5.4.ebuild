# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools udev

DESCRIPTION="CCID free software driver"
HOMEPAGE="https://ccid.apdu.fr https://github.com/LudovicRousseau/CCID"
SRC_URI="https://ccid.apdu.fr/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86"
IUSE="twinserial +usb"

RDEPEND="
	>=sys-apps/pcsc-lite-1.8.3
	twinserial? ( dev-lang/perl )
	usb? ( virtual/libusb:1 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-remove-flex-configure-dependency.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		LEX=: \
		$(use_enable twinserial) \
		$(use_enable usb libusb)
}

src_install() {
	default
	udev_newrules src/92_pcscd_ccid.rules 92-pcsc-ccid.rules
}

pkg_postinst() {
	udev_reload
	einfo "Check https://github.com/LudovicRousseau/CCID/blob/master/INSTALL"
	einfo "for more info about how to configure and use ccid"
}

pkg_postrm() {
	udev_reload
}
