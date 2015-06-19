# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/session/session-2.3a.ebuild,v 1.5 2014/08/10 17:44:31 slyfox Exp $

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="When you start Emacs, Session restores various variables from your last session"
HOMEPAGE="http://emacs-session.sourceforge.net/"
SRC_URI="mirror://sourceforge/emacs-session/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

S="${WORKDIR}/${PN}/lisp"
SITEFILE="50${PN}-gentoo.el"
DOCS="../INSTALL ../README ChangeLog"
DOC_CONTENTS="Add the following to your ~/.emacs to use session:
	\n\t(require 'session)
	\n\t(add-hook 'after-init-hook 'session-initialize)"
