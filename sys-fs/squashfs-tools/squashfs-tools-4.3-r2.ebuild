# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils toolchain-funcs flag-o-matic

DEB_VER="3"

DESCRIPTION="Tool for creating compressed filesystem type squashfs"
HOMEPAGE="http://squashfs.sourceforge.net"
SRC_URI="mirror://sourceforge/squashfs/squashfs${PV}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${DEB_VER}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
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

S="${WORKDIR}/squashfs${PV}/${PN}"

src_prepare() {
	epatch "${WORKDIR}"/debian/patches/*.patch
	epatch "${FILESDIR}"/${P}-sysmacros.patch
	epatch "${FILESDIR}"/${P}-aligned-data.patch
	epatch "${FILESDIR}"/${P}-2gb.patch
	epatch "${FILESDIR}"/${P}-local-cve-fix.patch
	epatch "${FILESDIR}"/${P}-mem-overflow.patch
	epatch "${FILESDIR}"/${P}-xattrs.patch
}

use10() { usex $1 1 0 ; }

src_configure() {
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
	emake "${EMAKE_SQUASHFS_CONF[@]}"
}

src_install() {
	dobin mksquashfs unsquashfs
	cd ..
	dodoc CHANGES PERFORMANCE.README pseudo-file.example README* OLD-READMEs/*
	doman "${WORKDIR}"/debian/manpages/*.[0-9]
}
