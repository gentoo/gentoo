# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="The Typing of Emacs -- an Elisp parody of The Typing of the Dead for Dreamcast"
HOMEPAGE="https://www.emacswiki.org/emacs/TypingOfEmacs"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

SITEFILE="50${PN}-gentoo.el"
