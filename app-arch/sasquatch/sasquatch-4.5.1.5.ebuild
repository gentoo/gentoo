# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_PV="$(ver_rs 3 '-')"
MY_P="${PN}-v${MY_PV}"
DESCRIPTION="An extended version of sasquashfs-tools"
HOMEPAGE="https://github.com/onekey-sec/sasquatch"
SRC_URI="https://github.com/onekey-sec/sasquatch/archive/refs/tags/${MY_P}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug deprecated lz4 lzma lzo xattr zstd"

REQUIRED_USE="
	deprecated? ( !lzma )
	lzma? ( !deprecated )
"

DEPEND="
	sys-libs/zlib
	lz4? ( app-arch/lz4 )
	lzma? ( app-arch/xz-utils )
	lzo? ( dev-libs/lzo )
	xattr? ( sys-apps/attr )
	zstd? ( app-arch/zstd )
"

RDEPEND=${DEPEND}

PATCHES=( "${FILESDIR}/${P}_signal-fix.patch" )

use10() {
	usex "${1}" 1 0
}

src_compile() {
	# set up make command line variables in EMAKE_SQUASHFS_CONF
	local opts=(
		LZMA_XZ_SUPPORT=$(use10 deprecated)
		LZO_SUPPORT=$(use10 lzo)
		LZ4_SUPPORT=$(use10 lz4)
		XATTR_SUPPORT=$(use10 xattr)
		XZ_SUPPORT=$(use10 lzma)
		ZSTD_SUPPORT=$(use10 zstd)
	)

	tc-export CC
	use debug && append-cppflags -DSQUASHFS_TRACE
	emake "${opts[@]}" -C squashfs-tools
}

src_install() {
	dobin squashfs-tools/sasquatch
	dodoc ACKNOWLEDGEMENTS CHANGES README*
	doman manpages/*.1
}
