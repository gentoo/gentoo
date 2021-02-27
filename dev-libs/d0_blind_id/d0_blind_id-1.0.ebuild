# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Blind-ID library for user identification using RSA blind signatures"
HOMEPAGE="http://git.xonotic.org/?p=xonotic/d0_blind_id.git;a=summary"
SRC_URI="https://github.com/divVerent/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="dev-libs/gmp:0"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( d0_blind_id.txt )

PATCHES=(
	"${FILESDIR}/${P}-slibtool.patch"
)

src_prepare() {
	default

	# fix out-of-source build
	sed -i \
		-e 's, d0_rijndael.c, "$srcdir/d0_rijndael.c",' \
		configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-rijndael
		--without-openssl
		--without-tfm
		--without-tommath
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
