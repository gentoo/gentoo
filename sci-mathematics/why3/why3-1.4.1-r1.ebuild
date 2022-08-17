# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools findlib

DESCRIPTION="Platform for deductive program verification"
HOMEPAGE="https://why3.lri.fr/"
SRC_URI="https://why3.gitlabpages.inria.fr/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="coq doc emacs gtk +ocamlopt re sexp +zarith zip"

RDEPEND="
	!sci-mathematics/why3-for-spark
	>=dev-lang/ocaml-4.05.0:=[ocamlopt?]
	>=dev-ml/menhir-20170418:=
	dev-ml/num:=
	coq? ( >=sci-mathematics/coq-8.6 )
	emacs? ( app-editors/emacs:* )
	gtk? ( dev-ml/lablgtk:=[sourceview,ocamlopt?] )
	re? ( dev-ml/re:= )
	sexp? (
		dev-ml/ppx_deriving:=[ocamlopt?]
		dev-ml/ppx_sexp_conv:=[ocamlopt?]
		dev-ml/sexplib:=[ocamlopt?]
	)
	zarith? ( dev-ml/zarith:= )
	zip? ( dev-ml/camlzip:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		dev-python/sphinx
		dev-python/sphinxcontrib-bibtex
		media-gfx/graphviz
		dev-texlive/texlive-latex
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexextra
	)
"

DOCS=( CHANGES.md README.md )

src_prepare() {
	mv configure.in configure.ac || die
	sed -i 's/configure\.in/configure.ac/g' Makefile.in || die
	sed -e '/^lib\/why3[a-z]*\$(EXE):/{n;s/-Wall/$(CFLAGS) $(LDFLAGS)/}' \
		-e '/^%.o: %.c/{n;s/\$(CC).*-o/$(CC) $(CFLAGS) -o/}' \
		-e '/\$(SPHINX)/s/ -d doc\/\.doctrees / /' \
		-i Makefile.in || die

	eautoreconf
	default
}

src_configure() {
	local myconf=(
		--disable-hypothesis-selection
		--disable-pvs-libs
		--disable-isabelle-libs
		--disable-frama-c
		--disable-infer
		--disable-web-ide
		$(use_enable coq coq-libs)
		$(use_enable doc)
		$(use_enable emacs emacs-compilation)
		$(use_enable gtk ide)
		$(use_enable ocamlopt native-code)
		$(use_enable re)
		$(use_enable sexp pp-sexp)
		$(use_enable zarith)
		$(use_enable zip)
	)
	econf "${myconf[@]}"
}

src_compile() {
	emake
	emake plugins
	use doc && emake doc
}

src_install(){
	findlib_src_preinst
	emake install install-lib DESTDIR="${ED}"

	einstalldocs
	docompress -x /usr/share/doc/${PF}/examples
	dodoc -r examples
	if use doc; then
		dodoc doc/latex/manual.pdf
		dodoc -r doc/html
	fi
}
