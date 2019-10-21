# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic git-r3 toolchain-funcs

DESCRIPTION="tools to create and extract Squashfs filesystems"
HOMEPAGE="
	http://squashfs.sourceforge.net
	https://github.com/plougher/squashfs-tools
"
EGIT_REPO_URI="https://github.com/plougher/${PN}"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug lz4 lzma lzo static xattr +xz zstd"
KEYWORDS=""

LIB_DEPEND="
	!xz? ( !lzo? ( sys-libs/zlib[static-libs(+)] ) )
	lz4? ( app-arch/lz4[static-libs(+)] )
	lzma? ( app-arch/xz-utils[static-libs(+)] )
	lzo? ( dev-libs/lzo[static-libs(+)] )
	sys-libs/zlib[static-libs(+)]
	xattr? ( sys-apps/attr[static-libs(+)] )
	xz? ( app-arch/xz-utils[static-libs(+)] )
	zstd? ( app-arch/zstd[static-libs(+)] )
"
RDEPEND="
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
"
DEPEND="
	${RDEPEND}
	static? ( ${LIB_DEPEND} )
"
PATCHES=(
	"${FILESDIR}"/${PN}-4.3-sysmacros.patch
)

use10() { usex $1 1 0 ; }

src_configure() {
	cd "${WORKDIR}"/${P}/${PN} || die

	# set up make command line variables in EMAKE_SQUASHFS_CONF
	EMAKE_SQUASHFS_CONF=(
		LZ4_SUPPORT=$(use10 lz4)
		LZMA_XZ_SUPPORT=$(use10 lzma)
		LZO_SUPPORT=$(use10 lzo)
		XATTR_SUPPORT=$(use10 xattr)
		XZ_SUPPORT=$(use10 xz)
		ZSTD_SUPPORT=$(use10 zstd)
	)

	tc-export CC
	use debug && append-cppflags -DSQUASHFS_TRACE
	use static && append-ldflags -static
}

src_compile() {
	cd "${WORKDIR}"/${P}/${PN} || die
	emake "${EMAKE_SQUASHFS_CONF[@]}"
}

src_install() {
	dobin "${WORKDIR}"/${P}/${PN}/{mksquashfs,unsquashfs}
	dodoc CHANGES README RELEASE-READMEs/*
}
