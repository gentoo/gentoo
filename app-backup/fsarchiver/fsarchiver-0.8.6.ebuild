# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Flexible filesystem archiver for backup and deployment tool"
HOMEPAGE="https://www.fsarchiver.org"
SRC_URI="https://github.com/fdupoux/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug lz4 lzma lzo static +zstd"

CDEPEND="dev-libs/libgcrypt:0=
	>=sys-fs/e2fsprogs-1.41.4
	lz4? ( app-arch/lz4 )
	lzma? ( >=app-arch/xz-utils-4.999.9_beta )
	lzo? ( >=dev-libs/lzo-2.02 )
	zstd? ( app-arch/zstd )
"
DEPEND="${CDEPEND}
	static? (
		app-arch/bzip2[static-libs]
		dev-libs/libgcrypt:0=[static-libs]
		dev-libs/libgpg-error[static-libs]
		sys-apps/util-linux[static-libs]
		>=sys-fs/e2fsprogs-1.41.4[static-libs]
		sys-libs/e2fsprogs-libs[static-libs]
		sys-libs/zlib[static-libs]
		lz4? ( app-arch/lz4[static-libs] )
		lzma? ( app-arch/xz-utils[static-libs] )
		lzo? ( dev-libs/lzo[static-libs] )
		zstd? ( app-arch/zstd[static-libs] )
	)"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i -e 's/^\([a-z]*_CFLAGS.*\)-ggdb/\1/' src/Makefile.am \
		|| die "seding failed"
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug devel)
		$(use_enable lz4)
		$(use_enable lzma)
		$(use_enable lzo)
		$(use_enable static)
		$(use_enable zstd)
	)
	econf "${myeconfargs[@]}"
}
