# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal toolchain-funcs usr-ldscript

DESCRIPTION="Userspace access to USB devices"
HOMEPAGE="https://libusb.info/ https://github.com/libusb/libusb"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 -x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug doc examples static-libs test udev"

RDEPEND="udev? ( >=virtual/libudev-208:=[${MULTILIB_USEDEP},static-libs?] )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	!udev? ( virtual/os-headers )"

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		$(use_enable udev) \
		$(use_enable debug debug-log) \
		$(use_enable test tests-build)
}

multilib_src_compile() {
	emake

	if multilib_is_native_abi; then
		use doc && emake -C doc docs
	fi
}

multilib_src_test() {
	emake check

	# noinst_PROGRAMS from tests/Makefile.am
	tests/stress || die
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi; then
		gen_usr_ldscript -a usb-1.0

		use doc && dohtml doc/html/*
	fi
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die

	dodoc AUTHORS ChangeLog NEWS PORTING README TODO

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.{c,h}
		insinto /usr/share/doc/${PF}/examples/getopt
		doins examples/getopt/*.{c,h}
	fi
}
