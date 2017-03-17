# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Library for manipulating zip archives"
HOMEPAGE="http://www.nih.at/libzip/"
SRC_URI="http://www.nih.at/libzip/${P}.tar.xz"

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="static-libs"

RDEPEND="
	sys-libs/zlib
	elibc_musl? ( sys-libs/fts-standalone )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS.md API-CHANGES THANKS )

PATCHES=(
	"${FILESDIR}/${P}-headers.patch"
	"${FILESDIR}/${P}-fts.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	use static-libs || rm "${D}"/usr/lib64/libzip.a || die
	find "${D}" -name '*.la' -delete || die
}
