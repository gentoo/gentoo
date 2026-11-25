# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp readme.gentoo-r1

DESCRIPTION="Minor mode for performing structured editing of S-expressions"
HOMEPAGE="https://paredit.org/
	https://www.emacswiki.org/emacs/ParEdit/
	https://github.com/emacsmirror/paredit/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacsmirror/${PN}"
else
	SRC_URI="https://github.com/emacsmirror/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~ppc ~sparc ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( CREDITS NEWS "${PN}.html" )
SITEFILE="50${PN}-gentoo-r1.el"

src_compile() {
	elisp_src_compile
	sh ./genhtml.sh || die "the script genhtml.sh failed"
}

src_test() {
	${EMACS} ${EMACSFLAGS} -l "${PN}.el" -l test.el || die "tests failed"
}

src_install() {
	local DOC_CONTENTS="If you wish to enable paredit mode for Lisp/Scheme
		based modes, then you can put this configuration into your GNU Emacs
		config:
		\n\t(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
		\n\t(add-hook 'lisp-mode-hook #'enable-paredit-mode)
		\n\t(add-hook 'scheme-mode-hook #'enable-paredit-mode)
		\n\t(add-hook 'slime-mode-hook #'enable-paredit-mode)"
	rm ./test.el* || die
	elisp_src_install
}
