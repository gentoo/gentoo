# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="27.1"

inherit elisp

DESCRIPTION="Generic interaction mode between Emacs and different Scheme implementations"
HOMEPAGE="https://gitlab.com/emacs-geiser/geiser/"
SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	app-text/texi2html
	sys-apps/texinfo
"

DOCS=( readme.org news.org doc/html )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	emake -C ./doc info web
}

src_install() {
	elisp_src_install
	doinfo ./doc/*.info
	einstalldocs
}
