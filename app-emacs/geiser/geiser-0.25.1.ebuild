# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Generic interaction mode between Emacs and different Scheme implementations"
HOMEPAGE="https://gitlab.com/emacs-geiser/geiser/"
SRC_URI="https://gitlab.com/emacs-geiser/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/transient"
BDEPEND="
	${RDEPEND}
	app-text/texi2html
	sys-apps/texinfo
"

DOCS=( readme.org news.org doc/html )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	BYTECOMPFLAGS="-L elisp" elisp-compile elisp/*.el

	emake -C doc info web
}

src_install() {
	elisp-install ${PN} elisp/*.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	doinfo doc/*.info
	einstalldocs
}
