# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Generic interaction mode between Emacs and different Scheme implementations"
HOMEPAGE="https://gitlab.com/emacs-geiser/geiser/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/emacs-${PN}/${PN}.git"
else
	SRC_URI="https://gitlab.com/emacs-${PN}/${PN}/-/archive/${PV}/${P}.tar.bz2"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	app-emacs/transient
"
BDEPEND="
	${RDEPEND}
	app-text/texi2html
	sys-apps/texinfo
"

DOCS=( readme.org news.org doc/html )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	BYTECOMPFLAGS="-L ./elisp" elisp-compile ./elisp/*.el
	emake -C ./doc info web
}

src_install() {
	elisp-install "${PN}" ./elisp/*.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	doinfo ./doc/*.info
	einstalldocs
}
