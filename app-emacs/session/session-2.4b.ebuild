# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

DESCRIPTION="When you start Emacs, Session restores various variables from your last session"
HOMEPAGE="http://emacs-session.sourceforge.net/"
SRC_URI="mirror://sourceforge/emacs-session/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

S="${WORKDIR}"
SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="Add the following to your ~/.emacs to use session:
	\n\t(require 'session)
	\n\t(add-hook 'after-init-hook 'session-initialize)"
