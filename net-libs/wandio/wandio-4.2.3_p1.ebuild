# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="C library for simple and efficient file IO"
HOMEPAGE="https://research.wand.net.nz/software/libwandio.php"
SRC_URI="https://github.com/wanduow/${PN}/archive/${PV/_p/-}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/6"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 http lzma lzo static-libs test zlib"
RESTRICT="!test? ( test )"

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
S=${WORKDIR}/${P/_p/-}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with bzip2) \
		$(use_with http) \
		$(use_with lzma) \
		$(use_with lzo) \
		$(use_with zlib)
}

src_test() {
	pushd test || die
	sh do-basic-tests.sh
}
