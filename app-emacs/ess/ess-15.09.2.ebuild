# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit elisp readme.gentoo-r1

MY_P="${PN}-${PV%.*}-${PV##*.}"
DESCRIPTION="Emacs Speaks Statistics"
HOMEPAGE="http://ess.r-project.org/"
SRC_URI="http://ess.r-project.org/downloads/ess/${MY_P}.tgz"

LICENSE="GPL-2+ GPL-3+ Texinfo-manual"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"

DEPEND="app-text/texi2html
	virtual/latex-base"

S="${WORKDIR}/${MY_P}"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	default
}

src_install() {
	emake PREFIX="${ED}/usr" \
		INFODIR="${ED}/usr/share/info" \
		LISPDIR="${ED}${SITELISP}/ess" \
		DOCDIR="${ED}/usr/share/doc/${PF}" \
		install

	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	# Most documentation is installed by the package's build system.
	rm -f "${ED}${SITELISP}/${PN}/ChangeLog"
	dodoc ChangeLog *NEWS doc/{TODO,ess-intro.pdf}
	newdoc doc/ChangeLog ChangeLog-doc
	newdoc lisp/ChangeLog ChangeLog-lisp

	DOC_CONTENTS="Please see /usr/share/doc/${PF} for the complete
		documentation. Usage hints are in ${SITELISP}/${PN}/ess-site.el ."
	readme.gentoo_create_doc
}
