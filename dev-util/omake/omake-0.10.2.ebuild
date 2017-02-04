# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs multilib eutils

RESTRICT="installsources"
DESCRIPTION="Make replacement"
HOMEPAGE="http://projects.camlcity.org/projects/omake.html"
SRC_URI="http://download.camlcity.org/download/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc fam ncurses +ocamlopt readline"
DEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	ncurses? ( >=sys-libs/ncurses-5.3:0= )
	fam? ( virtual/fam )
	readline? ( >=sys-libs/readline-4.3:0= )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-cflags.patch"
}

src_configure() {
	./configure \
		-prefix "${EPREFIX}/usr" \
		$(use readline || echo '-disable-readline') \
		$(use ncurses  || echo '-disable-ncurses' ) \
		$(use fam      || echo '-disable-fam'     ) \
		|| die
}

src_compile() {
	emake all
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc ChangeLog CONTRIBUTORS.org README.md
	if use doc; then
		dodoc doc/ps/omake-doc.{pdf,ps} doc/txt/omake-doc.txt
		dohtml -r doc/html/*
	fi
	use ocamlopt || export STRIP_MASK="*/bin/*"
}
