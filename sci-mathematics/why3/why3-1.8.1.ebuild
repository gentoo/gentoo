# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools findlib

DESCRIPTION="Platform for deductive program verification"
HOMEPAGE="https://www.why3.org/"
SRC_URI="https://why3.gitlabpages.inria.fr/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="coq doc emacs gtk +ocamlopt re sexp stackify zip"

RDEPEND="
	!sci-mathematics/why3-for-spark
	>=dev-lang/ocaml-4.05.0:=[ocamlopt?]
	>=dev-ml/menhir-20170418:=
	dev-ml/num:=
	dev-ml/zarith:=
	coq? (
		>=sci-mathematics/coq-8.15:=
		>=sci-mathematics/flocq-4.2.1
	)
	emacs? ( app-editors/emacs:* )
	gtk? ( dev-ml/lablgtk:=[sourceview,ocamlopt?] )
	re? ( dev-ml/re:= )
	sexp? (
		dev-ml/ppx_deriving:=[ocamlopt?]
		dev-ml/ppx_sexp_conv:=[ocamlopt?]
		dev-ml/sexplib:=[ocamlopt?]
	)
	stackify? ( dev-ml/ocamlgraph:=[ocamlopt?] )
	zip? ( dev-ml/camlzip:= )
"
DEPEND="
	${RDEPEND}
"
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
	rm configure || die
	mv configure.in configure.ac || die

	sed -e 's/configure\.in/configure.ac/g' \
		-i Makefile.in \
		|| die

	sed -e '/^lib\/why3[a-z]*\$(EXE):/{n;s/-Wall/$(CFLAGS) $(LDFLAGS)/}' \
		-e '/^%.o: %.c/{n;s/\$(CC).*-o/$(CC) $(CFLAGS) -o/}' \
		-e '/\$(SPHINX)/s/ -d doc\/\.doctrees / /' \
		-i Makefile.in \
		|| die

	sed -e '/^lib\/why3[a-z]*\$(EXE):/{n;s/-Wall/$(CFLAGS) $(LDFLAGS)/}' \
		-e '/^%.o: %.c/{n;s/\$(CC).*-o/$(CC) $(CFLAGS) -o/}' \
		-e '/\$(SPHINX)/s/ -d doc\/\.doctrees / /' \
		-i Makefile.in \
		|| die

	# remove QA warning about duplicated compressed file:
	rm examples/mlcfg/basic/why3shapes.gz || die

	eautoreconf
	default

	# Bad var replacement.
	sed -e 's|\$(OCAMLC -|\$(ocamlc -|g' \
		-i configure \
		|| die
}

src_configure() {
	local -x OCAMLC="ocamlc"

	local -a myconf=(
		--enable-verbose-make

		--disable-frama-c
		--disable-hypothesis-selection
		--disable-infer
		--disable-isabelle-libs
		--disable-java
		--disable-js-of-ocaml
		--disable-pvs-libs
		--disable-web-ide

		$(use_enable coq coq-libs)
		$(use_enable doc)
		$(use_enable emacs emacs-compilation)
		$(use_enable gtk ide)
		$(use_enable ocamlopt native-code)
		$(use_enable re)
		$(use_enable sexp)
		$(use_enable stackify)
		$(use_enable zip)
	)
	econf "${myconf[@]}"
}

src_compile() {
	emake

	if use doc ; then
		emake doc
	fi
}

src_install(){
	findlib_src_preinst
	emake DESTDIR="${ED}" install install-lib

	einstalldocs
	docompress -x "/usr/share/doc/${PF}/examples"
	dodoc -r examples

	if use doc; then
		dodoc doc/latex/manual.pdf
		dodoc -r doc/html
	fi
}
