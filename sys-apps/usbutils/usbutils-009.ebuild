# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="USB enumeration utilities"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/usb/usbutils/
	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usbutils.git/"
SRC_URI="https://www.kernel.org/pub/linux/utils/usb/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="virtual/libusb:1=
	virtual/libudev:="
DEPEND="${CDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	sys-apps/hwids
	python? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	use python && python_fix_shebang lsusb.py.in
}

src_configure() {
	econf \
		--datarootdir="${EPREFIX}/usr/share" \
		--datadir="${EPREFIX}/usr/share/misc"
}

src_install() {
	default
	newdoc usbhid-dump/NEWS NEWS.usbhid-dump

	use python || rm -f "${ED}"/usr/bin/lsusb.py
}
