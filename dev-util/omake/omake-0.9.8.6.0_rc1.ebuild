# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs multilib versionator eutils

MY_PV=$(replace_version_separator 5 '.' "$(replace_version_separator 4 '-' )")
RESTRICT="installsources"
DESCRIPTION="Make replacement"
HOMEPAGE="http://omake.metaprl.org/"
SRC_URI="http://omake.metaprl.org/downloads/${PN}-${MY_PV}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="doc fam ncurses +ocamlopt readline"
DEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	ncurses? ( >=sys-libs/ncurses-5.3:0= )
	fam? ( virtual/fam )
	readline? ( >=sys-libs/readline-4.3:0= )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${MY_PV%-*}

use_boolean() {
	if use $1; then
		echo "true"
	else
		echo "false"
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-cflags.patch" \
		"${FILESDIR}/${P}-warnerror.patch"
}

src_configure() {
	# Configuration steps...
	echo "PREFIX = \$(dir \$\"/usr\")" > .config
	echo "BINDIR = \$(dir \$\"\$(PREFIX)/bin\")" >> .config
	echo "LIBDIR = \$(dir \$\"\$(PREFIX)/$(get_libdir)\")" >> .config
	echo "MANDIR = \$(dir \$\"\$(PREFIX)/man\")" >> .config

	echo "CC = $(tc-getCC)" >> .config
	echo "CFLAGS = ${CFLAGS}" >> .config

	if use ocamlopt; then
		echo "NATIVE_ENABLED = true" >> .config
		echo "BYTE_ENABLED = false" >> .config
	else
		echo "NATIVE_ENABLED = false" >> .config
		echo "BYTE_ENABLED = true" >> .config
	fi

	echo "NATIVE_PROFILE = false" >> .config

	echo "READLINE_ENABLED = $(use_boolean readline)" >> .config
	echo "FAM_ENABLED = $(use_boolean fam)" >> .config
	echo "NCURSES_ENABLED = $(use_boolean ncurses)" >> .config

	echo "DEFAULT_SAVE_INTERVAL = 60" >> .config

	echo "OCAMLDEP_MODULES_ENABLED = false" >> .config
}

src_compile() {
	emake all
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc CHANGELOG.txt
	if use doc; then
		dodoc doc/ps/omake-doc.{pdf,ps} doc/txt/omake-doc.txt
		dohtml -r doc/html/*
	fi
	use ocamlopt || export STRIP_MASK="*/bin/*"
}
