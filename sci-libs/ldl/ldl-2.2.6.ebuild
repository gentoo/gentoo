# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple but educational LDL^T matrix factorization algorithm"
HOMEPAGE="http://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/kiwifb/suitesparse_splitbuild/releases/download/v5.4.0/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ppc ppc64 ~sparc ~x86"
IUSE="doc static-libs"

BDEPEND="virtual/pkgconfig
	doc? ( virtual/latex-base )"
DEPEND="sci-libs/suitesparseconfig"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_with doc) \
		$(use_enable static-libs static)
}
