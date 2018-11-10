# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Protect Emacs buffers from accidental killing"
HOMEPAGE="http://www.splode.com/~friedman/software/emacs-lisp/
	https://www.emacswiki.org/emacs/ProtectingBuffers"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

SITEFILE="50${PN}-gentoo.el"
