# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Drop-down menu interface"
HOMEPAGE="https://www.emacswiki.org/emacs/dropdown-list.el"
SRC_URI="https://distfiles.gentoo.org/pub/proj/emacs/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ELISP_PATCHES="${PN}-20090814-selection-face.patch"
SITEFILE="50${PN}-gentoo.el"
