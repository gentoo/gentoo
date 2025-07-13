# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A non-blocking DNS resolver library"
HOMEPAGE="https://www.monkey.org/~provos/libdnsres/"
SRC_URI="https://www.monkey.org/~provos/${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="static-libs"

DEPEND="dev-libs/libevent"
RDEPEND="${DEPEND}"

DOCS=( README )
PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-autotools-fix-path.patch
	"${FILESDIR}"/${P}-C99.patch
	"${FILESDIR}"/${P}-modern-types.patch
	"${FILESDIR}"/${P}-musl.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
