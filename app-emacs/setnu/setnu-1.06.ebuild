# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Display line numbers in Emacs buffers"
HOMEPAGE="https://web.archive.org/web/20211024223941/http://www.wonderworks.com/
	https://www.emacswiki.org/emacs/LineNumbers"
SRC_URI="https://distfiles.gentoo.org/pub/proj/emacs/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

SITEFILE="50${PN}-gentoo.el"
