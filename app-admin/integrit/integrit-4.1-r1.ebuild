# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="file integrity verification program"
HOMEPAGE="http://integrit.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

PATCHES=( "${FILESDIR}"/${PN}-4.1-fix-build-system.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	mv hashtbl/configure.{in,ac} || die

	# tests are not executable
	chmod +x test/test || die

	eautoreconf
}

src_compile() {
	emake
	emake utils

	emake -C doc
	emake -C hashtbl hashtest
}

src_install() {
	dosbin integrit
	dolib.a libintegrit.a
	dodoc Changes HACKING README todo.txt

	# utils
	dosbin utils/i-viewdb
	dobin utils/i-ls

	# hashtbl
	dolib.a hashtbl/libhashtbl.a
	doheader hashtbl/hashtbl.h
	dobin hashtbl/hashtest
	newdoc hashtbl/README README.hashtbl

	# doc
	doman doc/{i-ls.1,i-viewdb.1,integrit.1}
	doinfo doc/integrit.info

	# examples
	dodoc -r examples
}

pkg_postinst() {
	elog "It is recommended that the integrit binary is copied to a secure"
	elog "location and re-copied at runtime or run from a secure medium."
	elog "You should also create a configuration file (see examples)."
}
