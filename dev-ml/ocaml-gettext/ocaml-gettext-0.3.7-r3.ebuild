# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools findlib

DESCRIPTION="Provides support for internationalization of OCaml program"
HOMEPAGE="https://github.com/gildor478/ocaml-gettext"
SRC_URI="https://github.com/gildor478/ocaml-gettext/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/ocaml-unsafe-string.patch )

BDEPEND="
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)
"
# OCaml 4.10 does not support -unsafe-string by default
# bug #666149
RDEPEND="
	>=dev-lang/ocaml-3.12.1:=
	<dev-lang/ocaml-4.10.0:=
	>=dev-ml/ocaml-fileutils-0.4.0:=
	>=dev-ml/camomile-0.8.3:=
	sys-devel/gettext
	dev-ml/camlp4:=
	!dev-ml/ocaml-gettext-stub
"
DEPEND="
	${RDEPEND}
	test? ( dev-ml/ounit )
"

src_prepare() {
	default
	eautoreconf
}

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
