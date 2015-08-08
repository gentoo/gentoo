# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="Elisp client for the LysKOM conference system"
HOMEPAGE="http://www.lysator.liu.se/lyskom/klienter/emacslisp/index.en.html"
# snapshot of git://git.lysator.liu.se/${PN}/${PN}.git
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE="linguas_sv"

S="${WORKDIR}/${PN}"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	emake -C src EMACS=emacs
	# Info page is in Swedish only
	use linguas_sv && emake -C doc elisp-client
}

src_install() {
	elisp-install ${PN} src/lyskom.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc src/{ChangeLog*,README,TODO} doc/NEWS*
	use linguas_sv && doinfo doc/elisp-client

	DOC_CONTENTS="If you prefer an English language environment, add the
		following line to your ~/.emacs file:
		\n\t(setq-default kom-default-language 'en)"
	readme.gentoo_create_doc
}
