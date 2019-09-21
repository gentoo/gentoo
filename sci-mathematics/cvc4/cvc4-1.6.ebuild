# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="automatic theorem prover for satisfiability modulo theories (SMT) problems"
HOMEPAGE="http://cvc4.cs.stanford.edu/web/"
SRC_URI="http://cvc4.cs.stanford.edu/downloads/builds/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cln"

RDEPEND="dev-libs/antlr-c
	dev-libs/boost
	cln? ( sci-libs/cln )
	!cln? ( dev-libs/gmp:= )"
DEPEND="${RDEPEND}"

src_configure () {
	econf --enable-gpl \
		$(use_with cln)
}
