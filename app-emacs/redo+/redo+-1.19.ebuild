# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/redo+/redo+-1.19.ebuild,v 1.4 2014/05/17 14:00:11 ago Exp $

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="Redo/undo system for Emacs"
HOMEPAGE="http://www.emacswiki.org/emacs/RedoPlus
	http://www11.atwiki.jp/s-irie/pages/18.html"
# taken from http://www.emacswiki.org/emacs/${PN}.el
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 x86"

SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="Add \"(require 'redo+)\" to your ~/.emacs file
	to enable the redo/undo system."
