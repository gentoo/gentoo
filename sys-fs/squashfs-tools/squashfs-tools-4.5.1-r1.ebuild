# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit flag-o-matic toolchain-funcs

DESCRIPTION="tools to create and extract Squashfs filesystems"
HOMEPAGE="https://github.com/plougher/squashfs-tools/"
SRC_URI="
	https://github.com/plougher/squashfs-tools/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="debug lz4 lzma lzo xattr zstd"

RDEPEND="
	sys-libs/zlib
	lz4? ( app-arch/lz4 )
	lzma? ( app-arch/xz-utils )
	lzo? ( dev-libs/lzo )
	xattr? ( sys-apps/attr )
	zstd? ( app-arch/zstd )
"
DEPEND=${RDEPEND}

use10() { usex "${1}" 1 0; }

src_configure() {
	# set up make command line variables in EMAKE_SQUASHFS_CONF
	EMAKE_SQUASHFS_CONF=(
		LZMA_XZ_SUPPORT=$(use10 lzma)
		LZO_SUPPORT=$(use10 lzo)
		LZ4_SUPPORT=$(use10 lz4)
		XATTR_SUPPORT=$(use10 xattr)
		XZ_SUPPORT=$(use10 lzma)
		ZSTD_SUPPORT=$(use10 zstd)
	)

	tc-export CC
	use debug && append-cppflags -DSQUASHFS_TRACE
}

src_compile() {
	emake "${EMAKE_SQUASHFS_CONF[@]}" -C squashfs-tools
}

src_install() {
	dobin squashfs-tools/{mksquashfs,unsquashfs}
	dodoc ACKNOWLEDGEMENTS CHANGES README*
	dodoc -r RELEASE-READMEs
	doman manpages/*.1

	dosym unsquashfs /usr/bin/sqfscat
	dosym mksquashfs /usr/bin/sqfstar
}
