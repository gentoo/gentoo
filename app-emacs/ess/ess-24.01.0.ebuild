# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="Emacs Speaks Statistics"
HOMEPAGE="https://ess.r-project.org/
	https://github.com/emacs-ess/ESS/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-ess/${PN^^}.git"
else
	SRC_URI="https://github.com/emacs-ess/${PN^^}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN^^}-${PV}"

	KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2+ GPL-3+ Texinfo-manual"
SLOT="0"

BDEPEND="
	app-text/texi2html
	dev-texlive/texlive-fontsextra
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-mathscience
	dev-texlive/texlive-plaingeneric
	virtual/latex-base
"

DOCS=( ChangeLog NEWS ONEWS README
	   doc/html/{ess,news,readme}.html doc/{ess,readme}.pdf )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed -e "s|font-lock-reference-face|font-lock-constant-face|g" \
		-i lisp/*.el || die
}

src_compile() {
	local -x BYTECOMPFLAGS="-L lisp -L lisp/obsolete"

	elisp-compile lisp/*.el lisp/obsolete/*.el
	emake autoloads
	emake -C doc all html pdf
}

src_test() {
	elisp-test-ert . -L lisp -L test -l test/ess-test.el
}

src_install() {
	# Version >=18 doesn't install *.el files any more #685978
	elisp-install "${PN}" lisp/*.{el,elc} lisp/obsolete/*.{el,elc}
	elisp-make-site-file "${SITEFILE}" "${PN}" "(load \"ess-autoloads\" nil t)"

	insinto "${SITEETC}/${PN}"
	doins -r etc/*

	doinfo ./doc/info/ess.info

	local DOC_CONTENTS="\
		Please see /usr/share/doc/${PF} for the complete documentation."
	readme.gentoo_create_doc

	einstalldocs
}
