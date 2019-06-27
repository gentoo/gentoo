# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

DESCRIPTION="Emacs Speaks Statistics"
HOMEPAGE="http://ess.r-project.org/"
SRC_URI="http://ess.r-project.org/downloads/ess/${P}.tgz"

LICENSE="GPL-2+ GPL-3+ Texinfo-manual"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
RESTRICT="test"

BDEPEND="app-text/texi2html
	virtual/latex-base"

SITEFILE="50${PN}-gentoo.el"

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
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	# Most documentation is installed by the package's build system.
	dodoc ChangeLog *NEWS doc/TODO
	newdoc doc/ChangeLog ChangeLog-doc

	DOC_CONTENTS="Please see /usr/share/doc/${PF} for the complete
		documentation. Usage hints are in ${SITELISP}/${PN}/ess-site.el ."
	readme.gentoo_create_doc
}
