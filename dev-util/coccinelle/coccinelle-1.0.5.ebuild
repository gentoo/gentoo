# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit multilib eutils python-single-r1 bash-completion-r1 elisp-common

MY_P="${P/_/-}"
DESCRIPTION="Program matching and transformation engine"
HOMEPAGE="http://coccinelle.lip6.fr/"
SRC_URI="http://coccinelle.lip6.fr/distrib/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs ocaml +ocamlopt pcre python test vim-syntax"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# ocaml enables ocaml scripting (uses findlib)
CDEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt?]
	dev-ml/sexplib:=[ocamlopt?]
	dev-ml/menhir:=[ocamlopt?]
	dev-ml/camlp4:=[ocamlopt?]
	dev-ml/parmap:=[ocamlopt?]
	emacs? ( virtual/emacs )
	ocaml? ( dev-ml/findlib:= )
	pcre? ( dev-ml/pcre-ocaml:=[ocamlopt?] )
	python? ( ${PYTHON_DEPS} )"

RDEPEND="${CDEPEND}
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"

# dev-texlive/texlive-fontsextra contains 'ifsym.sty'
DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? (
		virtual/latex-base
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-fontsextra
	)"

DOCS=( authors.txt bugs.txt changes.txt credits.txt readme.txt )

S=${WORKDIR}/${MY_P}

SITEFILE=50coccinelle-gentoo.el

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	if use python ; then
		# fix python install location
		sed -e "s:\$(LIBDIR)/python:$(python_get_sitedir):" \
			-i Makefile || die
	fi
}

src_configure() {
	econf \
		$(use_enable python) \
		$(use_enable ocaml) \
		$(use_enable pcre) \
		$(use_enable pcre pcre-syntax) \
		$(use_enable ocamlopt opt)
}

src_compile() {
	emake depend

	if use ocamlopt ; then
		emake all.opt
	else
		emake TARGET_SPATCH=byte-only all-dev
	fi

	if use doc ; then
		VARTEXFONTS="${T}"/fonts emake docs
	fi

	if use emacs ; then
		elisp-compile editors/emacs/cocci.el || die
	fi
}

src_test() {
	emake check
	use python && emake pycocci-check
}

src_install() {
	default

	use doc && dodoc docs/manual/*.pdf
	newbashcomp scripts/spatch.bash_completion spatch

	if use emacs ; then
		elisp-install ${PN} editors/emacs/*
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	if use vim-syntax ; then
		newdoc editors/vim/README README-vim
		rm editors/vim/README || die
		insinto /usr/share/vim/vimfiles
		doins -r editors/vim/*
	fi

	use python && python_optimize

	export STRIP_MASK='*/coccinelle/spatch'
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
