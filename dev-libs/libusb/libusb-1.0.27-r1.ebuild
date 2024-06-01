# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool multilib-minimal

DESCRIPTION="Userspace access to USB devices"
HOMEPAGE="https://libusb.info/ https://github.com/libusb/libusb"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug doc examples static-libs test udev"
RESTRICT="!test? ( test )"
REQUIRED_USE="static-libs? ( !udev )"

RDEPEND="udev? ( >=virtual/libudev-208:=[${MULTILIB_USEDEP}] )"
DEPEND="
	${RDEPEND}
	!udev? ( virtual/os-headers )
"
BDEPEND="doc? ( app-text/doxygen )"

src_prepare() {
	default
	elibtoolize
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable udev)
		$(use_enable debug debug-log)
		$(use_enable test tests-build)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake

	if multilib_is_native_abi; then
		use doc && emake -C doc
	fi
}

multilib_src_test() {
	emake check

	# noinst_PROGRAMS from tests/Makefile.am
	if [[ -e /dev/bus/usb ]]; then
		tests/stress || die
	else
		# bug #824266
		ewarn "/dev/bus/usb does not exist, skipping stress test"
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi; then
		use doc && dodoc -r doc/api-1.0
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name "*.la" -delete || die

	dodoc AUTHORS ChangeLog NEWS PORTING README TODO

	if use examples; then
		docinto examples
		dodoc examples/*.{c,h}
	fi
}
