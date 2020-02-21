# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Automatic theorem prover"
HOMEPAGE="https://alt-ergo.ocamlpro.com"
SRC_URI="https://alt-ergo.ocamlpro.com/http/${P}/${P}.tar.gz"

LICENSE="CeCILL-C"
SLOT="0"
KEYWORDS="amd64"
IUSE="examples gtk +ocamlopt"

DEPEND=">=dev-lang/ocaml-3.12.1[ocamlopt?]
	dev-ml/zarith
	gtk? ( >=dev-ml/lablgtk-2.14[sourceview,ocamlopt?] )
	dev-ml/camlzip
	sci-mathematics/psmt2-frontend
	>=dev-ml/ocplib-simplex-0.4
	>=dev-ml/menhir-20181006
	dev-ml/seq
	dev-ml/dune"
RDEPEND="${DEPEND}"

DOCS=( CHANGES INSTALL.md README.md )

src_configure() {
	./configure --prefix /usr --libdir=/usr/$(get_libdir)
}

src_compile() {
	emake lib
	emake bin
	use gtk && emake gui
}

src_install() {
	default
	use gtk && emake DESTDIR="${D}" install-gui
	use examples && dodoc -r examples
	mv "${D}"/usr/doc/* "${D}"/usr/share/doc/${PF}/ || die
	rmdir "${D}"/usr/doc || die
}
