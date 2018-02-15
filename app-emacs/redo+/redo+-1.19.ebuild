# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="Redo/undo system for Emacs"
HOMEPAGE="https://www.emacswiki.org/emacs/RedoPlus
	https://www11.atwiki.jp/s-irie/pages/18.html"
# taken from http://www.emacswiki.org/emacs/${PN}.el
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 x86"

SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="Add \"(require 'redo+)\" to your ~/.emacs file
	to enable the redo/undo system."
