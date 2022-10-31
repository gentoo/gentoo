# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 elisp-common optfeature

DESCRIPTION="A semantic grep for the C language"
HOMEPAGE="https://home.regit.org/software/coccigrep/"
SRC_URI="https://github.com/regit/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs"

RDEPEND="
	dev-util/coccinelle[python,${PYTHON_SINGLE_USEDEP}]
	emacs? ( >=app-editors/emacs-23.1:* )
"
BDEPEND="
	doc? ( dev-python/sphinx )
	emacs? ( >=app-editors/emacs-23.1:* )
"

PATCHES=( "${FILESDIR}"/${P}-sphinx.patch )

SITEFILE="50${PN}-gentoo.el"

python_compile_all() {
	use doc && emake -C doc html

	if use emacs ; then
		elisp-compile editors/*.el || die
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )

	distutils-r1_python_install_all

	doman ${PN}.1

	if use emacs ; then
		elisp-install ${PN} editors/*.{el,elc} || die
		elisp-site-file-install "${FILESDIR}"/${SITEFILE} || die
	fi

	insinto /usr/share/vim/vimfiles/plugin
	doins editors/cocci-grep.vim
}

pkg_postinst() {
	use emacs && elisp-site-regen

	optfeature "Syntax highlighting (colorized output formats)" dev-python/pygments
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
