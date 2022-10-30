# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit autotools bash-completion-r1 elisp-common python-single-r1

DESCRIPTION="Program matching and transformation engine"
HOMEPAGE="https://coccinelle.gitlabpages.inria.fr/website/ https://gitlab.inria.fr/coccinelle/coccinelle"
SRC_URI="https://gitlab.inria.fr/coccinelle/coccinelle/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs +ocamlopt pcre python test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
# Test failures need investigation
RESTRICT="strip !test? ( test ) test"

RDEPEND="
	>=dev-lang/ocaml-3.12:=[ocamlopt?]
	dev-ml/sexplib:=[ocamlopt(+)?]
	dev-ml/menhir:=[ocamlopt?]
	dev-ml/camlp4:=[ocamlopt?]
	dev-ml/parmap:=[ocamlopt?]
	dev-ml/findlib:=[ocamlopt?]
	emacs? ( >=app-editors/emacs-23.1:* )
	pcre? (
		dev-libs/libpcre
		dev-ml/pcre-ocaml:=[ocamlopt?]
	)
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
# dev-texlive/texlive-fontsextra contains 'ifsym.sty'
BDEPEND="
	virtual/pkgconfig
	doc? (
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-fontsextra
		virtual/latex-base
		dev-tex/hevea
	)
"

DOCS=( authors.txt bugs.txt changes.txt credits.txt readme.txt )

SITEFILE=50coccinelle-gentoo.el

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	eautoreconf

	if use python ; then
		# Fix python install location
		sed -e "s:\$(LIBDIR)/python:$(python_get_sitedir):" \
			-i Makefile || die
	fi
}

src_configure() {
	local myeconfargs=(
		--enable-ocaml
		--with-bash-completion="$(get_bashcompdir)"
		--with-python="${EPYTHON}"

		$(use_enable python)
		$(use_enable pcre)
		$(use_enable pcre pcre-syntax)
		$(use_enable ocamlopt opt)
	)

	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
}

src_compile() {
	export TARGET_SPATCH=$(usev !ocamlopt 'byte-only')

	emake VERBOSE=yes -j1 $(usex ocamlopt 'all.opt' 'all-dev')

	if use doc ; then
		VARTEXFONTS="${T}"/fonts emake VERBOSE=yes docs
	fi

	if use emacs ; then
		elisp-compile editors/emacs/cocci.el || die
	fi
}

src_test() {
	# TODO: See Fedora's method?
	# https://src.fedoraproject.org/rpms/coccinelle/blob/rawhide/f/coccinelle.spec#_231
	emake VERBOSE=yes check $(usev python pycocci-check)
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}" VERBOSE=yes install

	if use python ; then
		python_optimize
	else
		rm -rf "${ED}/usr/$(get_libdir)/${PN}/python" || die
	fi

	if use emacs ; then
		elisp-install ${PN} editors/emacs/*
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	use doc && dodoc docs/manual/*.pdf

	newdoc editors/vim/README README-vim
	rm editors/vim/README || die
	insinto /usr/share/vim/vimfiles
	doins -r editors/vim/*
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
