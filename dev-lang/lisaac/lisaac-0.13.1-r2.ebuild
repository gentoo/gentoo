# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/lisaac/lisaac-0.13.1-r2.ebuild,v 1.1 2012/06/21 12:05:40 jlec Exp $

EAPI="4"
inherit versionator elisp-common eutils

DESCRIPTION="Lisaac is an object prototype based language"
HOMEPAGE="http://isaacproject.u-strasbg.fr/li.html"
SRC_URI="http://isaacproject.u-strasbg.fr/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vim-syntax emacs examples"

DEPEND="vim-syntax? ( app-editors/vim )
		emacs? ( virtual/emacs )"

RDEPEND="${DEPEND}"

SITEFILE=50${PN}-gentoo.el

src_prepare(){
	epatch "${FILESDIR}/${P}-makefile.patch"
	rm lib/number/essai
}

src_compile(){
	emake CC="$(tc-getCC)"

	if use emacs; then
		elisp-compile editor/emacs/lisaac-mode.el \
			|| die "compiling emacs component failed."
	fi
}

src_install(){
	emake DESTDIR="${D}" DOC="/usr/share/doc/${PF}" install

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax/
		doins editor/vim/syntax/lisaac.vim
		insinto /usr/share/vim/vimfiles/indent/
		doins editor/vim/indent/lisaac.vim
	fi

	if use emacs; then
		elisp-install ${PN} editor/emacs/*.{el,elc} \
			|| die "installing emacs coponent failed."
		elisp-site-file-install "${FILESDIR}"/${SITEFILE} \
			|| die "installing emacs site file failed"
	fi

	if use examples; then
		dodir /usr/share/${PN}/
		cp -r example "${ED}"/usr/share/${PN}/examples
	fi
}

pkg_postinst(){
	if use vim-syntax; then
		elog "Add the following line to your vimrc if you want"
		elog "to enable the lisaac support :"
		elog
		elog "au BufNewFile,BufRead *.li setf lisaac"
	fi

	use emacs && elisp-site-regen
}

pkg_postrm(){
	use emacs && elisp-site-regen
}
