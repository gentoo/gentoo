# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A terminal mail notification program (replacement for biff)"
HOMEPAGE="http://www.transbay.net/~enf/sw.html"
SRC_URI="http://www.transbay.net/~enf/${P}.tar"

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ppc x86"

S="${WORKDIR}/${PN}"

src_prepare() {
	# Fix configure to use ncurses instead of termcap (bug #103105)
	eapply "${FILESDIR}/${P}-ncurses.patch"

	# Fix Makefile.in to use our CFLAGS and LDFLAGS
	sed -i -e "s/^CFLAGS=-O/CFLAGS=${CFLAGS}/" \
		-e "s/^LDFLAGS=.*/LDFLAGS=${LDFLAGS}/" Makefile.in || die

	# Rebuild the compilation framework
	default
	eautoreconf
}

src_install() {
	dobin hap
	doman hap.1
	dodoc README HISTORY
}
