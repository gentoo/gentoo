# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic gap-pkg

DESCRIPTION="Graphs, digraphs, and multidigraphs in GAP"
SLOT="0"
SRC_URI="https://github.com/digraphs/Digraphs/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64"

DEPEND="sci-mathematics/gap:=
	sci-mathematics/planarity
	sci-libs/bliss:="
RDEPEND="${DEPEND}
	dev-gap/io
	dev-gap/orb
	dev-gap/datastructures"

DOCS=( CHANGELOG.md README.md )

GAP_PKG_EXTRA_INSTALL=( data notebooks )
gap-pkg_enable_tests

src_prepare() {
	default

	# Fix the build with pathological CFLAGS
	eautoreconf
}

src_configure() {
	# https://github.com/digraphs/Digraphs/issues/596
	append-cflags -Wno-error=strict-prototypes

	gap-pkg_econf \
		--with-external-planarity \
		--with-external-bliss
}
