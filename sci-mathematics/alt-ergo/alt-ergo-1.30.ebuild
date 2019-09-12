# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
	<=dev-ml/ocplib-simplex-0.3"
RDEPEND="${DEPEND}"

DOCS=( CHANGES INSTALL.md README.md )

src_compile() {
	emake
	use gtk && emake gui
}

src_install() {
	default
	use gtk && emake DESTDIR="${D}" install-gui
	use examples && dodoc -r examples
}
