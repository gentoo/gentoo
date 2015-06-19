# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-gettext/ocaml-gettext-0.3.5.ebuild,v 1.2 2014/11/28 18:07:50 aballier Exp $

EAPI=5

inherit findlib

DESCRIPTION="Provides support for internationalization of OCaml program"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocaml-gettext"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1433/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND=">=dev-lang/ocaml-3.12.1:=
	>=dev-ml/ocaml-fileutils-0.4.0:=
	>=dev-ml/camomile-0.8.3:=
	sys-devel/gettext
	|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )
	"
DEPEND="${RDEPEND}
	doc? ( app-text/docbook-xsl-stylesheets dev-libs/libxslt )
	test? ( dev-ml/ounit )"

src_configure() {
	econf \
		--with-docbook-stylesheet="${EPREFIX}/usr/share/sgml/docbook/xsl-stylesheets/" \
		$(use_enable doc) \
		$(use_enable test)
}

src_compile() {
	emake -j1
}

src_install() {
	findlib_src_preinst
	emake -j1 DESTDIR="${D}" \
		BINDIR="${ED}/usr/bin" \
		PODIR="${ED}/usr/share/locale/" \
		DOCDIR="${ED}/usr/share/doc/${PF}" \
		MANDIR="${ED}/usr/share/man" \
		install
	dodoc CHANGELOG README THANKS TODO
}
