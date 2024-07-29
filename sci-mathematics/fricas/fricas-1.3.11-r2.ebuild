# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
VIRTUALX_REQUIRED="doc"
inherit virtualx elisp-common

DESCRIPTION="FriCAS is a fork of Axiom computer algebra system"
HOMEPAGE="https://fricas.sourceforge.net/
	https://github.com/fricas/fricas
	https://fricas.github.io/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PV}/${P}-full.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+sbcl cmucl gcl ecl clisp clozurecl X emacs gmp doc"
REQUIRED_USE="^^ ( sbcl cmucl gcl ecl clisp clozurecl )
	gmp? ( ^^ ( sbcl clozurecl ) )"
RDEPEND="sbcl? ( dev-lisp/sbcl:= )
	cmucl? ( dev-lisp/cmucl:= )
	gcl? ( dev-lisp/gcl:= )
	ecl? ( dev-lisp/ecl:= )
	clisp? ( dev-lisp/clisp:= )
	clozurecl? ( dev-lisp/clozurecl:= )
	X? ( x11-libs/libXpm x11-libs/libICE )
	emacs? ( >=app-editors/emacs-23.1:* )
	gmp? ( dev-libs/gmp:= )"
DEPEND="${RDEPEND}
	doc? ( dev-texlive/texlive-basic
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-mathscience
		dev-tex/pgf )"

# necessary for clisp and gcl
RESTRICT="strip"

PATCHES=( "${FILESDIR}"/${P}-doc.patch )

src_configure() {
	local LISP GMP
	use sbcl && LISP="sbcl --dynamic-space-size 4096"
	use cmucl && LISP=lisp
	use gcl && LISP=gcl
	use ecl && LISP=ecl
	use clisp && LISP=clisp
	use clozurecl && LISP=ccl

	if use sbcl || use clozurecl
	then GMP=$(use_with gmp)
	else GMP=''
	fi

	# aldor is not yet in portage
	econf --disable-aldor --with-lisp="${LISP}" $(use_with X x) ${GMP}
}

src_compile() {
	default
	if use doc; then
		pushd src/doc > /dev/null || die "pushd src/doc failed"
		virtx emake book
		popd > /dev/null
	fi
}

src_test() {
	emake -j1 all-input
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	dodoc README.rst FAQ

	if use emacs; then
		sed -e "s|(setq load-path (cons (quote \"/usr/$(get_libdir)/fricas/emacs\") load-path)) ||" \
			-i "${D}"/usr/bin/efricas \
			|| die "sed efricas failed"
		elisp-install ${PN} "${D}"/usr/$(get_libdir)/${PN}/emacs/*.el
		elisp-make-site-file 64${PN}-gentoo.el
	else
		rm "${D}"/usr/bin/efricas || die "rm efricas failed"
	fi
	rm -r "${D}"/usr/$(get_libdir)/${PN}/emacs || die "rm -r emacs failed"

	if use doc; then
		dodoc src/doc/book.pdf
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
