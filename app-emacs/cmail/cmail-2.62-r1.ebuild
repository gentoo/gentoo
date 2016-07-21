# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit elisp

DESCRIPTION="A simple mail management system for Emacs"
HOMEPAGE="http://cmail.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/2191/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="l10n_ja"

RDEPEND="app-emacs/apel
	virtual/emacs-flim
	app-emacs/semi"

SITEFILE="70cmail-gentoo.el"

src_compile() {
	emake EMACS="${EMACS}" FLAGS="${EMACSFLAGS}" || die "emake failed"
}

src_install() {
	emake EMACS="${EMACS}" \
		FLAGS="${EMACSFLAGS} \
		  --eval \"(setq CMAIL_ICON_DIR \\\"${D}${SITEETC}/${PN}/icon\\\")\"" \
		PREFIX="${D}/usr" \
		LISPDIR="${D}/${SITELISP}" \
		INFODIR="${D}/usr/share/info" \
		VERSION_SPECIFIC_LISPDIR="${D}/${SITELISP}" install \
		|| die "emake install failed"

	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die

	dodoc ChangeLog INTRO.en README.en sample.* \
		doc/README.{POP,gnuspop3}.en doc/cmail-r2c.en.doc || die "dodoc failed"

	if use l10n_ja; then
		dodoc README.ja RELNOTES.ja doc/FAQ \
			doc/README.{FETCHMAIL,POP,bbdb,cmail-crypt,cvs-access} \
			doc/README.{feedmail,folders,gnuspop3,imap4} \
			doc/README.{multi-account,multi-highlight,nickname} \
			doc/cmail-r2c.doc doc/glossary || die "dodoc failed"
	else
		rm -f "${D}"/usr/share/info/cmail.info*
	fi
}
