# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 autotools vim-doc xdg

DESCRIPTION="Console file manager with vi(m)-like keybindings"
HOMEPAGE="https://vifm.info/"
EGIT_REPO_URI="https://github.com/vifm/vifm.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="developer +extended-keys gtk +magic +vim +vim-syntax X"

DEPEND="
	>=sys-libs/ncurses-5.9-r3:0
	magic? ( sys-apps/file )
	gtk? ( x11-libs/gtk+:2 )
	X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}
	vim? ( || ( app-editors/vim app-editors/gvim ) )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable developer) \
		$(use_enable extended-keys) \
		$(use_with magic libmagic) \
		$(use_with gtk) \
		$(use_with X X11)
}

src_install() {
	default

	if use vim; then
		local t
		for t in app plugin; do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins -r data/vim/doc/${t}/${PN}*
		done
	fi

	if use vim-syntax; then
		local t
		for t in ftdetect ftplugin syntax; do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins -r data/vim/${t}/${PN}*
		done
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	if use vim; then
		update_vim_helptags

		if [[ -n ${REPLACING_VERSIONS} ]]; then
			elog
			elog "You don't need to copy or link any files for"
			elog "  the vim plugin and documentation to work anymore."
			elog "If you copied any vifm files to ~/.vim/ manually"
			elog "  in earlier vifm versions, please delete them."
		fi
		elog
		elog "To use vim in vifm to view the documentation"
		elog "  edit ~/.vifm/vifmrc and set vimhelp instead of novimhelp"
		elog
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	use vim && update_vim_helptags
}
