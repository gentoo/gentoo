# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="MTD userspace tools (NFTL, JFFS2, NAND, FTL, UBI)"
HOMEPAGE="http://www.linux-mtd.infradead.org/ https://git.infradead.org/?p=mtd-utils.git;a=summary"
SRC_URI="https://infraroot.at/pub/mtd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ~ppc64 ~riscv x86"
IUSE="+lzo selinux +ssl test ubifs xattr +zstd"
REQUIRED_USE="ubifs? ( lzo ssl xattr zstd )"
RESTRICT="!test? ( test )"

DEPEND="
	sys-apps/util-linux:=
	virtual/zlib:=
	lzo? ( dev-libs/lzo:= )
	selinux? ( sys-libs/libselinux )
	ssl? ( dev-libs/openssl:= )
	xattr? ( sys-apps/acl )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-util/cmocka )"

DOCS=( jffsX-utils/device_table.txt )

src_configure() {
	# Tests fail with LTO (cmocka, bug #943725)
	filter-lto

	local myeconfargs=(
		--enable-ubihealthd
		# --with-tests is for test programs that are installed; was --enable-tests in earlier versions
		--with-tests
		--with-jffs
		--with-lsmtd
		--with-zlib
		$(use_enable test unit-tests)
		$(use_with lzo)
		$(use_with selinux)
		$(use_with ubifs)
		# UBIFS-specific crypto support
		$(use_with ubifs crypto)
		$(use_with zstd)
		$(use_with xattr)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	doman \
		jffsX-utils/mkfs.jffs2.1 \
		ubi-utils/ubinize.8
}
