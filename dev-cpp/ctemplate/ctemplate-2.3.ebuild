# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/ctemplate/ctemplate-2.3.ebuild,v 1.1 2014/12/19 11:46:12 pinkbyte Exp $

EAPI="5"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python2_7 )
inherit autotools-utils elisp-common python-any-r1

DESCRIPTION="A simple but powerful template language for C++"
HOMEPAGE="http://code.google.com/p/ctemplate/"
SRC_URI="http://dev.gentoo.org/~pinkbyte/distfiles/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc emacs vim-syntax static-libs test"

DEPEND="test? ( ${PYTHON_DEPS} )"
RDEPEND="vim-syntax? ( >=app-editors/vim-core-7 )
	emacs? ( virtual/emacs )"

DOCS=( AUTHORS ChangeLog NEWS README )

SITEFILE="70ctemplate-gentoo.el"

# Some tests are broken in 2.3
RESTRICT="test"

src_compile() {
	autotools-utils_src_compile

	if use emacs ; then
		elisp-compile contrib/tpl-mode.el || die "elisp-compile failed"
	fi
}

src_install() {
	autotools-utils_src_install

	# Installs just every piece
	rm -rf "${ED}/usr/share/doc"

	use doc && dohtml doc/*

	if use vim-syntax ; then
		cd "${S}/contrib"
		sh highlighting.vim || die "unpacking vim scripts failed"
		insinto /usr/share/vim/vimfiles
		doins -r .vim/*
	fi

	if use emacs ; then
		cd "${S}/contrib"
		elisp-install ${PN} tpl-mode.el tpl-mode.elc || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
