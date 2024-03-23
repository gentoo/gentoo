# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="GAP package for semigroups and monoids"
SLOT="0"
SRC_URI="https://github.com/semigroups/Semigroups/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64"

DEPEND="sci-mathematics/gap:=
	>=sci-libs/libsemigroups-2.7.3:="
RDEPEND="${DEPEND}
	dev-gap/orb
	dev-gap/io
	dev-gap/images
	dev-gap/datastructures
	dev-gap/digraphs
	dev-gap/genss"
BDEPEND="virtual/pkgconfig"

DOCS=( CHANGELOG.md README.md CONTRIBUTING.md )

GAP_PKG_EXTRA_INSTALL=( data )
gap-pkg_enable_tests

src_prepare() {
	# can't bundle it if it isn't there (belt and suspenders)
	rm -r libsemigroups || die
	default
}

src_configure() {
	gap-pkg_econf --with-external-libsemigroups
}
