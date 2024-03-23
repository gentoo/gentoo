# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="Emacs Speaks Statistics"
HOMEPAGE="https://ess.r-project.org/"
SRC_URI="https://ess.r-project.org/downloads/ess/${P}.tgz"

LICENSE="GPL-2+ GPL-3+ Texinfo-manual"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

BDEPEND="app-text/texi2html
	virtual/latex-base"

PATCHES=( "${FILESDIR}"/${P}-emacs-28.patch )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default
	sed -i -e 's/font-lock-reference-face/font-lock-constant-face/g' \
		lisp/*.el || die
}

src_compile() {
	default
}

src_install() {
	emake PREFIX="${ED}/usr" \
		LISPDIR="${ED}${SITELISP}/ess" \
		ETCDIR="${ED}${SITEETC}/ess" \
		DOCDIR="${ED}/usr/share/doc/${PF}" \
		install

	# Version 18* doesn't install *.el files any more #685978
	elisp-install ${PN} lisp/*.{el,elc} lisp/obsolete/*.{el,elc}
	elisp-make-site-file "${SITEFILE}" ${PN} "(load \"ess-autoloads\" nil t)"

	# Most documentation is installed by the package's build system.
	dodoc ChangeLog *NEWS doc/TODO
	newdoc doc/ChangeLog ChangeLog-doc

	local DOC_CONTENTS="\
		Please see /usr/share/doc/${PF} for the complete documentation."
	readme.gentoo_create_doc
}
