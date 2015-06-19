# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/eliom/eliom-3.0.3.ebuild,v 1.2 2013/08/19 13:21:14 aballier Exp $

EAPI=5

inherit eutils multilib findlib

DESCRIPTION="A web framework to program client/server applications"
HOMEPAGE="http://ocsigen.org/eliom/"
SRC_URI="http://www.ocsigen.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc +ocamlopt"

DEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt?]
	>=dev-ml/js_of_ocaml-1.3.2:=
	>=www-servers/ocsigenserver-2.2.0:=
	>=dev-ml/tyxml-2.1:=
	>=dev-ml/deriving-ocsigen-0.3:=
	dev-ml/react:=
	dev-ml/ocaml-ssl:=
	dev-ml/calendar:="
RDEPEND="${DEPEND}"

src_configure() {
	sh configure \
		--prefix "/usr" \
		--docdir "/usr/share/doc/${PF}/html" \
		--mandir "/usr/share/man/" \
		--temproot "${ED}" \
		--libdir "/usr/$(get_libdir)/ocaml" \
		|| die "configure failed"
}

src_compile() {
	if use ocamlopt ; then
		emake
	else
		emake byte
	fi
	use doc && emake doc -j1
}

src_test() {
	emake tests.byte
	use ocamlopt && emake tests.opt
}

src_install() {
	findlib_src_preinst
	if use ocamlopt; then
		emake install
	else
		emake install.byte
	fi
	use doc && emake install.doc
	dodoc CHANGES README
}
