# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/puff/puff-20100127.ebuild,v 1.3 2013/01/03 11:19:36 tomjbe Exp $

EAPI="2"

inherit flag-o-matic multilib

DESCRIPTION="microwave CAD software"
HOMEPAGE="http://wwwhome.cs.utwente.nl/~ptdeboer/ham/puff/"
SRC_URI="http://wwwhome.cs.utwente.nl/~ptdeboer/ham/${PN}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	dev-lang/fpc
	amd64? ( >=dev-lang/fpc-2.4.0 )"

src_prepare() {
	# fix lib path for X11 and dont ignore LDFLAGS
	sed -i -e "s#lib\\\/#$(get_libdir)\\\/#" \
		-e 's/CFLAGS/#CFLAGS/' \
		-e 's/link.res pu/link.res $(LDFLAGS) pu/' Makefile || die
}

src_compile() {
	LDFLAGS="$(raw-ldflags)"
	emake -j1 || die
}

src_install() {
	dobin puff || die

	dodoc changelog.txt README.txt || die
	newdoc "Puff Manual.pdf" Puff_Manual.pdf || die

	insinto /usr/share/${PN}
	doins setup.puf || die
	doins -r orig_dev_and_puf_files || die
}

pkg_postinst() {
	elog "You must copy /usr/share/${PN}/setup.puf into your working directory"
	elog "before using the program."
}
