# Copyright 2016-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="FUSE filesystem to mount squashfs archives"
HOMEPAGE="https://github.com/vasi/squashfuse"
SRC_URI="https://github.com/vasi/squashfuse/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="lz4 lzma lzo static-libs +zlib zstd"
REQUIRED_USE="|| ( lz4 lzma lzo zlib zstd )"

# Tests require access to /dev/fuse.
RESTRICT="test"
PROPERTIES="test_privileged"

DEPEND="
	>=sys-fs/fuse-3.16:3=
	lzma? ( >=app-arch/xz-utils-5.0.4:= )
	zlib? ( >=virtual/zlib-1.2.5-r2:= )
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
	local econfargs=(
		$(use_enable static-libs static)
		$(usev !lz4 --without-lz4)
		$(usev !lzma --without-xz)
		$(usev !lzo --without-lzo)
		$(usev !zlib --without-zlib)
		$(usev !zstd --without-zstd)
	)

	econf "${econfargs[@]}"
}

src_test() {
	addwrite /dev/fuse
	default
}

src_install() {
	default
	find "${ED}" -name "*.la" -type f -delete || die
}
