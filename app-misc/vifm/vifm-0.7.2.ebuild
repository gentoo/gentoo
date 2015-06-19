# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/vifm/vifm-0.7.2.ebuild,v 1.7 2015/05/04 09:26:53 nimiux Exp $

EAPI=4

inherit base

DESCRIPTION="Console file manager with vi(m)-like keybindings"
HOMEPAGE="http://http://vifm.info/"
SRC_URI="mirror://sourceforge/vifm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc s390 x86"
IUSE="+compatibility +extended-keys +magic vim-plugin vim-syntax"

DEPEND="
	>=sys-libs/ncurses-5.7-r7
	magic? ( sys-apps/file )
"
RDEPEND="
	${DEPEND}
	vim-plugin? ( >=app-editors/vim-7.3 )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
"

DOCS=( AUTHORS FAQ NEWS README TODO )

S="${WORKDIR}"

src_configure() {
	econf \
		$(use_enable compatibility compatibility-mode) \
		$(use_enable extended-keys) \
		$(use_with magic libmagic)
}

src_install() {
	base_src_install

	if use vim-syntax; then
		local t
		for t in ftdetect ftplugin syntax; do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins "${S}"/data/vim/"${t}"/"${PN}".vim
		done
	fi
	if use vim-plugin; then
		local t
		for t in doc plugin; do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins "${S}"/data/vim/"${t}"/"${PN}".*
		done
	fi
}

pkg_postinst() {
	elog "To use vim to view the vifm help, copy /usr/share/${P}/vifm.txt"
	elog "	to ~/.vim/doc/ and run ':helptags ~/.vim/doc' in vim,"
	elog "then edit ~/.vifm/vifmrc${PV/a/} and set USE_VIM_HELP=1"
	elog ""
	elog "To use the vifm plugin in vim, copy /usr/share/${P}/vifm.vim to"
	elog "	/usr/share/vim/vimXX/"
}
