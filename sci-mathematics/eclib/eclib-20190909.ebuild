# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Programs for elliptic curves defined over the rational numbers"
HOMEPAGE="https://www.warwick.ac.uk/~masgaj/mwrank/index.html"

# We use the SageMath tarball instead of the one from github because
# the github releases don't contain the "make dist" stuff and we would
# need autotools.eclass to generate it.
SRC_URI="http://files.sagemath.org/spkg/upstream/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/6"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="boost flint minimal static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="sci-mathematics/pari:=
	dev-libs/ntl:=
	boost? ( dev-libs/boost:= )
	flint? ( sci-mathematics/flint:= )"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(usex minimal --disable-allprogs "" "" "") \
		$(use_with boost) \
		$(use_with flint) \
		$(use_enable static-libs static)
}

src_install(){
	default
	find "${ED}" -name '*.la' -delete || die
}
