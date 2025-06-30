# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools dot-a

MY_PV="${PV/_/-}"

DESCRIPTION="file integrity verification program"
HOMEPAGE="https://integrit.sourceforge.net/"
SRC_URI="https://github.com/integrit/integrit/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

# Tests don't work in 4.2_rc1. Please re-check on version bump!
RESTRICT="test"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}/${PN}"-4.1-fix-build-system.patch
	# backport fix for https://github.com/integrit/integrit/issues/8
	# https://bugs.gentoo.org/941078
	"${FILESDIR}"/${P}-type-mismatch.patch
)

BDEPEND="sys-apps/texinfo"

src_prepare() {
	default
	mv configure.{in,ac} || die "Failed to move configure.in into .ac"
	mv hashtbl/configure.{in,ac} || die "Failed to move hashtbl/configure.in into .ac"

	eautoreconf
	touch ar-lib || die #775746
}

src_configure() {
	lto-guarantee-fat
	default
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

	strip-lto-bytecode
}

pkg_postinst() {
	elog "It is recommended that the integrit binary is copied to a secure"
	elog "location and re-copied at runtime or run from a secure medium."
	elog "You should also create a configuration file (see examples)."
}
