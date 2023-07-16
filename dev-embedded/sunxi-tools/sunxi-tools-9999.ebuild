# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit toolchain-funcs

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linux-sunxi/sunxi-tools"
	PROPERTIES="test_network"
	RESTRICT="test"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/linux-sunxi/sunxi-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="!test? ( test )"
fi

DESCRIPTION="A collection of command line tools for ARM devices with Allwinner SoCs"
HOMEPAGE="https://linux-sunxi.org/Main_Page"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

RDEPEND="acct-group/plugdev
	virtual/libusb:1
	virtual/udev"

DEPEND="${RDEPEND}
"

BDEPEND="virtual/pkgconfig"

PATCHES=(
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
