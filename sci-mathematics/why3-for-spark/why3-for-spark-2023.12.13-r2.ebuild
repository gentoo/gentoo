# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools findlib

ID=fb4ca6cd8c7d888d3e8d281e6de87c66ec20f084

DESCRIPTION="SPARK 2014 repository for the Why3 verification platform"
HOMEPAGE="https://www.why3.org/ https://github.com/AdaCore/why3"
SRC_URI="https://github.com/AdaCore/why3/archive/${ID}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/why3-${ID}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="coq doc emacs gtk html hypothesis-selection +ocamlopt sexp zarith zip"
RESTRICT="strip"

RDEPEND="
	dev-ml/menhir:=[ocamlopt?]
	dev-ml/num:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
	dev-ml/yojson:=
	coq? ( <=sci-mathematics/coq-8.18 )
	emacs? ( app-editors/emacs:* )
	gtk? ( dev-ml/lablgtk:=[sourceview] )
	html? ( dev-tex/hevea:= )
	hypothesis-selection? ( dev-ml/ocamlgraph:= )
	dev-ml/ppx_deriving:=[ocamlopt?]
	dev-ml/ppx_sexp_conv:=[ocamlopt?]
	dev-ml/sexplib:=[ocamlopt?]
	zarith? ( dev-ml/zarith:=[ocamlopt?] )
	zip? ( dev-ml/camlzip:=[ocamlopt?] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		dev-python/sphinx
		dev-python/sphinxcontrib-bibtex
		dev-tex/rubber
		media-gfx/graphviz
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2020-gentoo.patch
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${PN}-2021-make.patch #Bug #883167
	"${FILESDIR}"/${PN}-2020-bibtex.patch
	"${FILESDIR}"/${P}-spark.patch
	"${FILESDIR}"/${PN}-2021-sighandler.patch
)

QA_FLAGS_IGNORED=(
	'/usr/lib.*/why3/commands/.*cmxs'
	'/usr/lib.*/why3/plugins/.*cmxs'
	'/usr/lib.*/ocaml/why3/.*cmxs'
	/usr/bin/why3
	/usr/bin/why3config.cmxs
	/usr/bin/why3session.cmxs
	/usr/bin/gnat_server
	/usr/bin/gnatwhy3
	/usr/bin/why3realize.cmxs
	/usr/bin/why3ide.cmxs
)

# Forcing native for bug #913497
REQUIRED_USE="html? ( doc ) ocamlopt"

src_prepare() {
	find examples -name \*gz | xargs gunzip
	sed -i \
		-e 's:configure.in:configure.ac:g' \
		Makefile.in || die
	sed -i \
		-e 's: effect: effekt:g' \
		-e 's:(effect:(effekt:g' \
		-e 's:\.effect:\.effekt:g' \
		src/extract/mltree.ml \
		src/extract/mltree.mli \
		src/mlw/expr.ml \
		src/mlw/expr.mli \
		src/mlw/ity.ml \
		src/mlw/ity.mli \
		|| die
	sed -i \
		-e 's:Pervasives:Stdlib:g' \
		src/gnat/gnat_loc.ml \
		src/gnat/gnat_expl.ml \
		|| die
	mv configure.{in,ac} || die
	eautoreconf
	default
}

src_configure() {
	local myconf=(
		--disable-pvs-libs
		--disable-isabelle-libs
		--enable-verbose-make
		--enable-sexp
		$(use_enable coq coq-libs)
		$(use_enable doc)
		$(use_enable emacs emacs-compilation)
		$(use_enable gtk ide)
		$(use_enable html html-pdf)
		$(use_enable hypothesis-selection)
		$(use_enable ocamlopt native-code)
		$(use_enable zarith)
		$(use_enable zip)
	)
	econf "${myconf[@]}"
}

src_compile() {
	emake -j1
	if use ocamlopt; then
		emake byte
	fi
	use doc && emake doc
}

src_install() {
	emake DESTDIR="${D}" install_spark2014_dev
	local cmdPath=/usr/$(get_libdir)/why3/commands
	dosym ../why3server ${cmdPath}/why3server
	# Remove duplicated files
	for filename in config.cmxs ide.cmxs realize.cmxs server session.cmxs; do
		if [[ -e "${D}"${cmdPath}/why3${filename} ]]; then
			rm "${D}"${cmdPath}/why3${filename} || die
			dosym ../../../bin/why3${filename} ${cmdPath}/why3${filename}
		fi
	done
	rm "${D}"/usr/$(get_libdir)/why3/why3cpulimit
	dosym ../../bin/why3cpulimit /usr/$(get_libdir)/why3/why3cpulimit

	einstalldocs
	docompress -x /usr/share/doc/${PF}/examples
	dodoc -r examples
	if use doc; then
		use html && dodoc -r doc/html
	fi
}
