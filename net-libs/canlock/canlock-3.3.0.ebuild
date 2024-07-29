# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A library for creating and verifying Usenet cancel locks"
HOMEPAGE="https://micha.freeshell.org/libcanlock/"
SRC_URI="https://micha.freeshell.org/lib${PN}/src/lib${P}.tar.bz2"
S="${WORKDIR}/lib${P}"

LICENSE="BSD MIT"
SLOT="0/3"
KEYWORDS="amd64 arm ppc x86 ~amd64-linux ~x86-linux"
IUSE="header-parser +legacy"

BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
"

DOCS=( ChangeLog{,_V{0..2}} README TODO doc/sec_review.txt )

src_prepare() {
	default

	# shatest fails to build with slibtool
	sed 's/shatest$(EXEEXT) //g' -i test/Makefile.in || die
}

src_configure() {
	local econf_args=(
		--enable-pc-files
		$(use_enable header-parser hp)
		$(use_enable legacy legacy-api)
	)

	econf "${econf_args[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	# keep old header location for compability with canlock v2
	use legacy && dosym ./libcanlock-3/canlock.h /usr/include/canlock.h

	# required for =net-nntp/tin-2.6.0
	dosym ./libcanlock-3.pc /usr/$(get_libdir)/pkgconfig/libcanlock3.pc
}
