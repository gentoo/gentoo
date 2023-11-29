# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit python-single-r1

DESCRIPTION="USB enumeration utilities"
HOMEPAGE="
	https://www.kernel.org/pub/linux/utils/usb/usbutils/
	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usbutils.git/
"
SRC_URI="https://www.kernel.org/pub/linux/utils/usb/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	virtual/libusb:1=
	virtual/libudev:=
"
RDEPEND="
	${DEPEND}
	python? (
		${PYTHON_DEPS}
		sys-apps/hwdata
	)
"
BDEPEND="
	virtual/pkgconfig
	python? ( ${PYTHON_DEPS} )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	use python && python_fix_shebang lsusb.py.in
}

src_configure() {
	local myeconfargs=(
		--cache-file="${S}"/config.cache
		--datarootdir="${EPREFIX}/usr/share"
		--datadir="${EPREFIX}/usr/share/hwdata"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newdoc usbhid-dump/NEWS NEWS.usbhid-dump
	dobin usbreset # noinst_PROGRAMS, but installed by other distros

	if ! use python ; then
		rm -f "${ED}"/usr/bin/lsusb.py || die
	fi
}
