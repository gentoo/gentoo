# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C library for simple and efficient file IO"
HOMEPAGE="https://github.com/LibtraceTeam/wandio"
SRC_URI="https://github.com/LibtraceTeam/wandio/archive/refs/tags/${PV}-1.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${P}-1

LICENSE="LGPL-3"
SLOT="0/6"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 http lzma lzo lz4 test zlib zstd"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( bzip2 lzma lzo lz4 zlib zstd )"

RDEPEND="
	!<net-libs/libtrace-4
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	lzo? ( dev-libs/lzo:2 )
	lz4? ( app-arch/lz4:= )
	http? ( net-misc/curl )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd:= )
"
DEPEND="
	${RDEPEND}
	test? ( app-arch/lzop )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with bzip2) \
		$(use_with http) \
		$(use_with lzma) \
		$(use_with lzo) \
		$(use_with lz4) \
		$(use_with zlib) \
		$(use_with zstd)
}

src_test() {
	pushd test || die

	"${BROOT}"/bin/bash do-basic-tests.sh || die
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
