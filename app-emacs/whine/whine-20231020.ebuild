# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Complaint generator for GNU Emacs"
HOMEPAGE="https://www.emacswiki.org/emacs/Whine"
SRC_URI="https://distfiles.gentoo.org/pub/proj/emacs/${P}.el.xz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="amd64 x86"

SITEFILE="50${PN}-gentoo.el"
