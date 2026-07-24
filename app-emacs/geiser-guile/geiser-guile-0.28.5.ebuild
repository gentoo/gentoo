# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Guile's implementation of the Geiser protocols"
HOMEPAGE="https://gitlab.com/emacs-geiser/guile/"
SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	app-emacs/geiser
	app-emacs/transient
"
# Only calls 'guile' at runtime.
RDEPEND="
	${BDEPEND}
	dev-scheme/guile:*
"

PATCHES=( "${FILESDIR}/${PN}-guile-scheme-src-dir.patch" )
DOCS=( readme.org )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare
	sed -e "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" -i "${PN}.el" || die
}

src_install() {
	elisp_src_install
	insinto "${SITEETC}/${PN}"
	doins -r src
}
