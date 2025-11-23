# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Repology API access via Emacs Lisp"
HOMEPAGE="https://elpa.gnu.org/packages/repology.html"
SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ELISP_REMOVE="${PN}-pkg.el"
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert "${S}" -l ${PN}-tests.el

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
