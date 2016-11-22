# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 elisp-common

DESCRIPTION="A semantic grep for the C language"
HOMEPAGE="http://home.regit.org/software/coccigrep/"
SRC_URI="https://github.com/regit/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs vim"

RDEPEND="dev-util/coccinelle[python]
	emacs? ( virtual/emacs )
	vim? ( || ( app-editors/vim app-editors/gvim ) )"
DEPEND="doc? ( dev-python/sphinx )
	emacs? ( virtual/emacs )"

SITEFILE="50${PN}-gentoo.el"

python_compile_all() {
	use doc && emake -C doc html

	if use emacs ; then
		elisp-compile editors/*.el || die
	fi
}

python_install_all() {
	use doc && local HTML_DOCS="doc/_build/html/."
	distutils-r1_python_install_all

	doman ${PN}.1

	if use emacs ; then
		elisp-install ${PN} editors/*.{el,elc} || die
		elisp-site-file-install "${FILESDIR}"/${SITEFILE} || die
	fi

	if use vim ; then
		insinto /usr/share/vim/vimfiles/plugin
		doins editors/cocci-grep.vim
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen

	einfo "Syntax highlighting is supported through dev-python/pygments."
	einfo "Install it if you want colorized output formats."
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
