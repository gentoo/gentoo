# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WANT_AUTOMAKE="1.11"

inherit autotools

DESCRIPTION="Hyperdex fork/extension of leveldb"
HOMEPAGE="http://hyperdex.org/"
SRC_URI="http://hyperdex.org/src/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/leveldb:=[snappy]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/snappy.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
