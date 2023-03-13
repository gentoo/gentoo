# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Emacs major mode for editing Standard ML"
HOMEPAGE="http://www.iro.umontreal.ca/~monnier/elisp/
	https://elpa.gnu.org/packages/sml-mode.html"
SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"

DOCS=( README TODO )
ELISP_REMOVE="${PN}-pkg.el"
SITEFILE="50${PN}-gentoo-6.1.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
