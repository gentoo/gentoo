# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTICE: This package provides all "use-package" Emacs Lisp libraries except
# "bind-chord" and "bind-key" which are split into their own packages.

EAPI=8

NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Declaration macro for simplifying your Emacs configuration"
HOMEPAGE="https://github.com/jwiegley/use-package/"
SRC_URI="https://github.com/jwiegley/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	app-emacs/bind-chord
	app-emacs/bind-key
	app-emacs/diminish
	app-emacs/system-packages
"
BDEPEND="${RDEPEND}"

DOCS=( NEWS.md README.md )
PATCHES=( "${FILESDIR}"/${PN}-require-diminish.patch )

ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

src_test() {
	emake BATCH="${EMACS} ${EMACSFLAGS} -L . -l diminish" test
}

src_install() {
	rm bind-{chord,key}.el{,c} ${PN}-tests.el || die

	elisp_src_install
}
