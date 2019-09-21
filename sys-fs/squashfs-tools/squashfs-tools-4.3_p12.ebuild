# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic toolchain-funcs

DESCRIPTION="tools to create and extract Squashfs filesystems"
HOMEPAGE="http://squashfs.sourceforge.net"
SRC_URI="
	mirror://sourceforge/squashfs/squashfs${PV/_p*}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"
IUSE="debug lz4 lzma lzo static xattr +xz zstd"

LIB_DEPEND="
	sys-libs/zlib[static-libs(+)]
	!xz? ( !lzo? ( sys-libs/zlib[static-libs(+)] ) )
	lz4? ( app-arch/lz4[static-libs(+)] )
	lzma? ( app-arch/xz-utils[static-libs(+)] )
	lzo? ( dev-libs/lzo[static-libs(+)] )
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
	"${FILESDIR}"/${P/_p*}-sysmacros.patch
	"${FILESDIR}"/${P/_p*}-aligned-data.patch
	"${FILESDIR}"/${P/_p*}-local-cve-fix.patch
	"${FILESDIR}"/${P/_p*}-mem-overflow.patch
	"${FILESDIR}"/${P/_p*}-extmatch.patch
	"${FILESDIR}"/${P/_p*}-musl.patch
)

S="${WORKDIR}/squashfs${PV/_p*}/${PN}"

src_prepare() {
	eapply -p2 "${WORKDIR}"/debian/patches/*.patch
	eapply -p2 ${PATCHES[@]}
	eapply_user
}

use10() { usex $1 1 0 ; }

src_configure() {
	# restore GNU89 inline semantics to
	# emit function symbols, bug 595290
	append-cflags -std=gnu89

	# set up make command line variables in EMAKE_SQUASHFS_CONF
	EMAKE_SQUASHFS_CONF=(
		LZMA_XZ_SUPPORT=$(use10 lzma)
		LZO_SUPPORT=$(use10 lzo)
		LZ4_SUPPORT=$(use10 lz4)
		XATTR_SUPPORT=$(use10 xattr)
		XZ_SUPPORT=$(use10 xz)
		ZSTD_SUPPORT=$(use10 zstd)
	)

	tc-export CC
	use debug && append-cppflags -DSQUASHFS_TRACE
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
