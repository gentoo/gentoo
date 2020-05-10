# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="An Emacs major mode for editing X resource database files"
HOMEPAGE="https://launchpad.net/xrdb-mode
	https://www.emacswiki.org/emacs/ResourceFiles"
# taken from https://launchpad.net/${PN}/trunk/3.0/+download/${PN}.el
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=("${FILESDIR}"/${P}-backquotes.patch)
SITEFILE="50${PN}-gentoo.el"
