# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

MY_PV="v${PV}"
SRC_URI="https://github.com/linux-sunxi/sunxi-tools/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Tools for Allwinner A10 devices."
HOMEPAGE="http://linux-sunxi.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

RDEPEND="acct-group/plugdev
	virtual/libusb:1
	virtual/udev"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-respect-user-supplied-cflags.patch"
	"${FILESDIR}/${P}-fix-strncpy-compiler-warning.patch"
)

src_compile() {
	tc-export PKG_CONFIG

	emake LIBUSB_CFLAGS="$(${PKG_CONFIG} --cflags libusb-1.0)" \
		LIBUSB_LIBS="$(${PKG_CONFIG} --libs libusb-1.0)" \
		CC="$(tc-getCC)" tools misc
}

src_install() {
	dobin bin2fex fex2bin phoenix_info sunxi-nand-image-builder
	newbin sunxi-bootinfo bootinfo
	newbin sunxi-fel fel
	newbin sunxi-fexc fexc
	newbin sunxi-nand-part nand-part
}
