# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools gap-pkg

DESCRIPTION="Graphs, digraphs, and multidigraphs in GAP"
SRC_URI="https://github.com/digraphs/Digraphs/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

DEPEND="sci-mathematics/gap:=
	>=sci-mathematics/planarity-5:=
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

PATCHES=( "${FILESDIR}/digraphs-1.14-planarity-5.patch" )

GAP_PKG_EXTRA_INSTALL=( data notebooks )
gap-pkg_enable_tests

src_prepare() {
	# belt and suspenders
	rm -r extern/bliss-0.73 \
		extern/edge-addition-planarity-suite-Version_4.0.0.0 \
		|| die

	default
	eautoreconf
}

src_configure() {
	gap-pkg_econf \
		--with-external-planarity \
		--with-external-bliss
}
