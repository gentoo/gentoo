# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Kernel coredump file access"
HOMEPAGE="https://github.com/ptesarik/libkdumpfile"
SRC_URI="https://github.com/ptesarik/libkdumpfile/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="|| ( LGPL-3+ GPL-2+ )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="lzo snappy zlib zstd"

DEPEND="
	lzo? ( dev-libs/lzo )
	snappy? ( app-arch/snappy:= )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-c99.patch
	"${FILESDIR}"/${P}-disabled-compression-tests.patch
	"${FILESDIR}"/${P}-32-bit-tests.patch
)

src_prepare() {
	default

	# Can drop on next release >0.5.4
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		# The Python bindings within libkdumpfile are deprecated
		# and don't work w/ PEP517. There's a new CFFI bindings
		# project we can use if anyone asks for them.
		--without-python
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
