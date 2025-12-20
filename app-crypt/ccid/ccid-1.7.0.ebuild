# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson udev

DESCRIPTION="CCID free software driver"
HOMEPAGE="https://ccid.apdu.fr https://github.com/LudovicRousseau/CCID"
SRC_URI="https://ccid.apdu.fr/files/${P}.tar.xz"

LICENSE="LGPL-2.1+ LGPL-2+ GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="twinserial"

RDEPEND="
	sys-apps/pcsc-lite
	virtual/libusb:1
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/lex
	dev-lang/perl
	virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		$(meson_use twinserial serial)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	udev_newrules src/92_pcscd_ccid.rules 92-pcsc-ccid.rules
}

pkg_postinst() {
	udev_reload
	einfo "Check https://github.com/LudovicRousseau/CCID/blob/master/INSTALL.md"
	einfo "for more info about how to configure and use ccid"
}

pkg_postrm() {
	udev_reload
}
