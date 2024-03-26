# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Computes changes between binary or text files and creates deltas"
HOMEPAGE="https://xdelta.googlecode.com/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=dev-libs/glib-2
	>=sys-libs/zlib-1.1.4:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-m4.patch"
	"${FILESDIR}/${P}-glib2.patch"
	"${FILESDIR}/${P}-pkgconfig.patch"
	"${FILESDIR}/${P}-gzip.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC
	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
