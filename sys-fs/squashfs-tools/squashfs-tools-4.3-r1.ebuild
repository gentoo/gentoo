# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DEB_VER="3"

DESCRIPTION="Tool for creating compressed filesystem type squashfs"
HOMEPAGE="http://squashfs.sourceforge.net"
SRC_URI="mirror://sourceforge/squashfs/squashfs${PV}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${DEB_VER}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="lz4 lzma lzo xattr +xz"

RDEPEND="
	sys-libs/zlib
	!xz? ( !lzo? ( sys-libs/zlib ) )
	lz4? ( app-arch/lz4 )
	lzma? ( app-arch/xz-utils )
	lzo? ( dev-libs/lzo )
	xattr? ( sys-apps/attr )
	xz? ( app-arch/xz-utils )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/squashfs${PV}/${PN}"

src_prepare() {
	epatch "${WORKDIR}"/debian/patches/*.patch
	epatch "${FILESDIR}"/${P}-sysmacros.patch
	epatch "${FILESDIR}"/${P}-aligned-data.patch
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
