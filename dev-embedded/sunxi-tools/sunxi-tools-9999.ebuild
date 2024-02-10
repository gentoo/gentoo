# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit toolchain-funcs

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linux-sunxi/sunxi-tools"
	PROPERTIES="test_network"
	RESTRICT="test"
	RDEPEND="sys-apps/dtc
			sys-libs/zlib"
else
	KEYWORDS="~amd64"
	# We need this as zip, it is used during src_test
	SRC_URI="https://github.com/linux-sunxi/sunxi-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/linux-sunxi/sunxi-boards/archive/bc7410fed9e5d9b31cd1d6ae90462d06b513660e.zip \
		-> ${P}-test.zip )"
	RESTRICT="!test? ( test )"

	PATCHES=(
		"${FILESDIR}/${PN}-1.4.1-fix-strncpy-compiler-warning.patch"
	)
fi

DESCRIPTION="A collection of command line tools for ARM devices with Allwinner SoCs"
HOMEPAGE="https://linux-sunxi.org/Main_Page"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

RDEPEND+=" acct-group/plugdev
	virtual/libusb:1
	virtual/udev"

DEPEND="${RDEPEND}
"

BDEPEND="virtual/pkgconfig
	test? ( app-arch/unzip )"

src_unpack() {
	if [[ ${PV} = *9999* ]]; then
		git-r3_src_unpack
	else
		unpack ${P}.tar.gz
		# No need to unpack testdata twice
	fi
}

src_prepare() {
	default

	if [[ ${PV} != *9999* ]] && use test; then
		cp "${DISTDIR}/${P}-test.zip" "${S}/tests/sunxi-boards.zip" || die
		sed -i 's$sunxi-boards-master$sunxi-boards-bc7410fed9e5d9b31cd1d6ae90462d06b513660e$' tests/Makefile || die
		sed -i 's|^coverage:.*|coverage: $(BOARDS_DIR)/README|' tests/Makefile || die
	fi
}

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
