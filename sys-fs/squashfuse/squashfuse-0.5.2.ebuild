# Copyright 2016-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="FUSE filesystem to mount squashfs archives"
HOMEPAGE="https://github.com/vasi/squashfuse"
SRC_URI="https://github.com/vasi/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="lz4 lzma lzo static-libs +zlib zstd"
REQUIRED_USE="|| ( lz4 lzma lzo zlib zstd )"
RESTRICT="test" # Tests require access to /dev/fuse.

DEPEND="
	>=sys-fs/fuse-2.8.6:0=
	lzma? ( >=app-arch/xz-utils-5.0.4:= )
	zlib? ( >=sys-libs/zlib-1.2.5-r2:= )
	lzo? ( >=dev-libs/lzo-2.06:= )
	lz4? ( >=app-arch/lz4-0_p106:= )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	filter-lto
	filter-flags -fwhole-program -fno-common

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
	find "${ED}" -name "*.la" -type f -delete || die
}
