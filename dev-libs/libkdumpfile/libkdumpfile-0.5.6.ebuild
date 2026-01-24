# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Kernel coredump file access"
HOMEPAGE="https://codeberg.org/ptesarik/libkdumpfile"
SRC_URI="https://codeberg.org/ptesarik/libkdumpfile/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="|| ( LGPL-3+ GPL-2+ )"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="lzo snappy zlib zstd"

DEPEND="
	sys-libs/binutils-libs:=
	lzo? ( dev-libs/lzo )
	snappy? ( app-arch/snappy:= )
	zlib? ( virtual/zlib:= )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local myeconfargs=(
		$(use_with lzo lzo2)
		$(use_with snappy)
		$(use_with zlib)
		$(use_with zstd libzstd)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
