# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools usr-ldscript multilib-minimal

DESCRIPTION="Userspace access to USB devices (libusb-0.1 compat wrapper)"
HOMEPAGE="https://libusb.info"
SRC_URI="https://github.com/libusb/libusb-compat-0.1/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug examples"

RDEPEND="
	>=virtual/libusb-1-r1:1[${MULTILIB_USEDEP}]
	!dev-libs/libusb:0
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/libusb-config
)

src_prepare() {
	default

	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		$(use_enable debug debug-log)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
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
