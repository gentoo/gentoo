# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="An authoring and publishing environment for Emacs"
HOMEPAGE="https://www.gnu.org/software/emacs-muse/"
SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"

LICENSE="GPL-3+ FDL-1.2+ GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	app-emacs/htmlize
"
BDEPEND="
	${RDEPEND}
"

DOCS=( ChangeLog README )
ELISP_TEXINFO="texi/${PN}.texi"
SITEFILE="50${PN}-gentoo.el"
