# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Test system responsiveness to compare different kernels"
HOMEPAGE="http://members.optusnet.com.au/ckolivas/contest/"
SRC_URI="http://members.optusnet.com.au/ckolivas/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=app-benchmarks/dbench-2.0"
PATCHES=(
	"${FILESDIR}/${PN}-fortify_sources.patch"
	"${FILESDIR}/${P}-fix-buildsystem.patch"
)

src_prepare () {
	# fix #570250 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89

	default
	tc-export CC
}
src_compile() {
	emake
}

src_install() {
	dobin contest
	doman contest.1
	dodoc README
}
