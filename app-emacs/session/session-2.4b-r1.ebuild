# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="When you start Emacs, Session restores various variables from your last session"
HOMEPAGE="http://emacs-session.sourceforge.net/"

SRC_URI="https://downloads.sourceforge.net/emacs-session/${P}.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DOC_CONTENTS="Add the following to your ~/.emacs to use session:
	\n\t(require 'session)
	\n\t(add-hook 'after-init-hook 'session-initialize)"
SITEFILE="50${PN}-gentoo.el"
