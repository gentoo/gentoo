# Copyright 1999-2022 Gentoo Authors
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
IUSE="bzip2 http lzma lzo test zlib"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( lzma lzo )"

RDEPEND="
	!<net-libs/libtrace-4
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	lzo? ( dev-libs/lzo )
	http? ( net-misc/curl )
	zlib? ( sys-libs/zlib )
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
		$(use_with zlib)
}

src_test() {
	pushd test || die

	"${BROOT}"/bin/bash do-basic-tests.sh || die
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
