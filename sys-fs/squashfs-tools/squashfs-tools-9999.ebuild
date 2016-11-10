# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3 toolchain-funcs flag-o-matic

DEB_VER="3"

DESCRIPTION="Tool for creating compressed filesystem type squashfs"
HOMEPAGE="http://squashfs.sourceforge.net"
EGIT_REPO_URI="
	https://git.kernel.org/pub/scm/fs/squashfs/squashfs-tools.git
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="lz4 lzma lzo static xattr +xz"

LIB_DEPEND="sys-libs/zlib[static-libs(+)]
	!xz? ( !lzo? ( sys-libs/zlib[static-libs(+)] ) )
	lz4? ( app-arch/lz4[static-libs(+)] )
	lzma? ( app-arch/xz-utils[static-libs(+)] )
	lzo? ( dev-libs/lzo[static-libs(+)] )
	xattr? ( sys-apps/attr[static-libs(+)] )
	xz? ( app-arch/xz-utils[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3-sysmacros.patch
	"${FILESDIR}"/${PN}-4.3-aligned-data.patch
	"${FILESDIR}"/${PN}-4.3-xattrs.patch
)

use10() { usex $1 1 0 ; }

src_configure() {
	cd "${WORKDIR}"/${P}/${PN} || die

	# set up make command line variables in EMAKE_SQUASHFS_CONF
	EMAKE_SQUASHFS_CONF=(
		LZMA_XZ_SUPPORT=$(use10 lzma)
		LZO_SUPPORT=$(use10 lzo)
		LZ4_SUPPORT=$(use10 lz4)
		XATTR_SUPPORT=$(use10 xattr)
		XZ_SUPPORT=$(use10 xz)
	)

	tc-export CC
	use static && append-ldflags -static
}

src_compile() {
	cd "${WORKDIR}"/${P}/${PN} || die
	emake "${EMAKE_SQUASHFS_CONF[@]}"
}

src_install() {
	cd "${WORKDIR}"/${P}/${PN} || die
	dobin mksquashfs unsquashfs
	cd .. || die
	dodoc CHANGES README RELEASE-README RELEASE-READMEs/*
}
