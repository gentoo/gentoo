# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Library for manipulating zip archives"
HOMEPAGE="https://nih.at/libzip/"
SRC_URI="https://www.nih.at/libzip/${P}.tar.xz"

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="bzip2 static-libs"

RDEPEND="
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	elibc_musl? ( sys-libs/fts-standalone )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS.md API-CHANGES THANKS )

PATCHES=(
	"${FILESDIR}/${PN}-1.2.0-headers.patch"
	"${FILESDIR}/${PN}-1.2.0-fts.patch"
)

src_prepare() {
	default

	# fails in portage build only
	sed -i -e "/encryption-nonrandom-aes.*.test/d" regress/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf $(use_with bzip2)
}

src_install() {
	default
	use static-libs || rm "${ED%/}"/usr/$(get_libdir)/libzip.a || die
	find "${D}" -name '*.la' -delete || die
}
