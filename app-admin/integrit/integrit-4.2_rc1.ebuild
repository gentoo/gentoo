# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV="${PV/_/-}"

DESCRIPTION="file integrity verification program"
HOMEPAGE="http://integrit.sourceforge.net/"
SRC_URI="https://github.com/integrit/integrit/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

# Tests don't work in 4.2_rc1. Please re-check on version bump!
RESTRICT="test"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=( "${FILESDIR}"/${PN}-4.1-fix-build-system.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	mv hashtbl/configure.{in,ac} || die

	eautoreconf
	touch ar-lib || die #775746
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
