# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit usr-ldscript multilib-minimal

DESCRIPTION="Userspace access to USB devices (libusb-0.1 compat wrapper)"
HOMEPAGE="http://libusb.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/-compat}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug examples"

RDEPEND="
	>=virtual/libusb-1-r1:1[${MULTILIB_USEDEP}]
	!dev-libs/libusb:0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN/-compat}-0.1-ansi.patch )

MULTILIB_CHOST_TOOLS=(
	/usr/bin/libusb-config
)

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		$(use_enable debug debug-log)
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	gen_usr_ldscript -a usb
}

multilib_src_install_all() {
	einstalldocs

	if use examples; then
		docinto examples
		dodoc examples/*.c
	fi

	find "${ED}" -name '*.la' -delete || die
}
