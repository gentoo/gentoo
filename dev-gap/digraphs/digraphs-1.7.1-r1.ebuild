# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Graphs, digraphs, and multidigraphs in GAP"
SRC_URI="https://github.com/digraphs/Digraphs/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

DEPEND="sci-mathematics/gap:=
	sci-mathematics/planarity
	sci-libs/bliss:="
RDEPEND="${DEPEND}
	dev-gap/io
	dev-gap/orb
	dev-gap/datastructures"

# There are a few tests that will fail without a PDF viewer installed.
# Having xdg-open is good enough, and light weight, so it goes first.
BDEPEND="test? ( || (
	x11-misc/xdg-utils
	app-text/gv
	app-text/xpdf
	app-text/evince
	kde-apps/okular
) )"

DOCS=( CHANGELOG.md README.md )

GAP_PKG_EXTRA_INSTALL=( data notebooks )
gap-pkg_enable_tests

src_configure() {
	gap-pkg_econf \
		--with-external-planarity \
		--with-external-bliss
}
