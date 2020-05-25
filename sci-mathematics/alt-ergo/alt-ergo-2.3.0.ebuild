# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Automatic theorem prover"
HOMEPAGE="https://alt-ergo.ocamlpro.com"
SRC_URI="https://alt-ergo.ocamlpro.com/http/${P}/${P}.tar.gz"

LICENSE="CeCILL-C"
SLOT="0"
KEYWORDS="amd64"
IUSE="examples gtk +ocamlopt"

DEPEND=">=dev-lang/ocaml-4.09.0[ocamlopt?]
	dev-ml/zarith
	gtk? ( >=dev-ml/lablgtk-2.14[sourceview,ocamlopt?] )
	dev-ml/camlzip
	sci-mathematics/psmt2-frontend
	>=dev-ml/ocplib-simplex-0.4
	>=dev-ml/menhir-20181006
	dev-ml/seq
	dev-ml/dune
	dev-ml/num"
RDEPEND="${DEPEND}"

DOCS=( CHANGES INSTALL.md README.md )

QA_FLAGS_IGNORED=(
	/usr/lib*/alt-ergo-parsers/AltErgoParsers.cmxs
	/usr/lib*/alt-ergo-lib/AltErgoLib.cmxs
	/usr/bin/alt-ergo
)

src_prepare() {
	default
	find "${S}" -name \*.ml | xargs sed -i "s:Pervasives:Stdlib:g" || die
}

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
