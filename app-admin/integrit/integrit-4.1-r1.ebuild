# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools toolchain-funcs

DESCRIPTION="file integrity verification program"
HOMEPAGE="http://integrit.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_prepare() {
	sed -i -e "/^CC/d" configure.in hashtbl/configure.in || die
	sed -i -e "/^AC_PROGRAM_PATH/d" configure.in hashtbl/configure.in || die
	eautoreconf
	tc-export AR
}

src_compile() {
	emake
	emake utils

	cd "${S}"/doc && emake
	cd "${S}"/hashtbl && emake hashtest
}

src_test() {
	chmod +x test/test || die
	default
}

src_install() {
	dosbin integrit
	dolib libintegrit.a
	dodoc Changes HACKING README todo.txt

	cd "${S}"/utils
	dosbin i-viewdb
	dobin i-ls

	cd "${S}"/hashtbl
	dolib libhashtbl.a
	insinto /usr/include
	doins hashtbl.h
	dobin hashtest
	newdoc README README.hashtbl

	cd "${S}"/doc
	doman i-ls.1 i-viewdb.1 integrit.1
	doinfo integrit.info

	cd "${S}"/examples
	docinto examples
	dodoc *
}

pkg_postinst() {
	elog "It is recommended that the integrit binary is copied to a secure"
	elog "location and re-copied at runtime or run from a secure medium."
	elog "You should also create a configuration file (see examples)."
}
