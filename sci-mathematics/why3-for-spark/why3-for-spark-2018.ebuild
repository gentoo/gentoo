# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MYP=${PN}-gpl-${PV}-src

DESCRIPTION="Platform for deductive program verification"
HOMEPAGE="http://why3.lri.fr/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0819dec7a447df26c27a43
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="coq doc emacs gtk html hypothesis-selection +ocamlopt profiling zarith zip"
RESTRICT=strip

DEPEND=">=dev-lang/ocaml-4.02.3[ocamlopt?]
	dev-ml/menhir
	coq? ( sci-mathematics/coq )
	doc? ( dev-tex/rubber )
	gtk? ( dev-ml/lablgtk[sourceview] )
	emacs? ( virtual/emacs )
	html? ( dev-tex/hevea )
	hypothesis-selection? ( dev-ml/ocamlgraph )
	zarith? ( dev-ml/zarith )
	zip? ( >=dev-ml/camlzip-1.07 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

REQUIRED_USE="html? ( doc )"

src_configure() {
	econf \
		--disable-pvs-libs \
		--disable-isabelle-libs \
		$(use_enable coq coq-libs) \
		$(use_enable coq coq-tactic) \
		$(use_enable doc) \
		$(use_enable emacs emacs-compilation) \
		$(use_enable gtk ide) \
		$(use_enable html html-doc) \
		$(use_enable hypothesis-selection) \
		$(use_enable ocamlopt native-code) \
		$(use_enable profiling) \
		$(use_enable zarith) \
		$(use_enable zip)
}

src_compile() {
	emake -j1
	if use ocamlopt; then
		emake byte
	fi
	use doc && emake doc
}

src_install() {
	emake DESTDIR="${D}" -j1 install
	emake DESTDIR="${D}" -j1 install-lib
	emake DESTDIR="${D}" install_spark2014_dev
	einstalldocs
	docompress -x /usr/share/doc/${PF}/examples
	dodoc -r examples
	if use doc; then
		dodoc doc/manual.pdf
		use html && dodoc -r doc/html
	fi
}
