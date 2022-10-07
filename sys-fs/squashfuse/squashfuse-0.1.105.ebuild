# Copyright 2016-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic

DESCRIPTION="FUSE filesystem to mount squashfs archives"
HOMEPAGE="https://github.com/vasi/squashfuse"
SRC_URI="https://github.com/vasi/squashfuse/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="lz4 lzma lzo static-libs +zlib zstd"
REQUIRED_USE="|| ( lz4 lzma lzo zlib zstd )"

COMMON_DEPEND="
	>=sys-fs/fuse-2.8.6:0=
	lzma? ( >=app-arch/xz-utils-5.0.4:= )
	zlib? ( >=sys-libs/zlib-1.2.5-r2:= )
	lzo? ( >=dev-libs/lzo-2.06:= )
	lz4? ( >=app-arch/lz4-0_p106:= )
	zstd? ( app-arch/zstd:= )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"
# Tests require access to /dev/fuse.
RESTRICT+=" test"

src_configure() {
	filter-flags -flto* -fwhole-program -fno-common
	eautoreconf

	local econfargs=(
		$(use_enable static-libs static)
		$(use lz4 || echo --without-lz4)
		$(use lzma || echo  --without-xz)
		$(use lzo || echo --without-lzo)
		$(use zlib || echo --without-zlib)
		$(use zstd || echo --without-zstd)
	)

	econf "${econfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
