# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools vim-doc versionator xdg-utils

MY_P=$(replace_version_separator 4 '-' ${PF})

DESCRIPTION="Console file manager with vi(m)-like keybindings"
HOMEPAGE="https://vifm.info/"
SRC_URI="mirror://sourceforge/vifm/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X developer +extended-keys gtk +magic vim vim-syntax"

DEPEND="
	>=sys-libs/ncurses-5.9-r3:0
	magic? ( sys-apps/file )
	gtk? ( x11-libs/gtk+:2 )
	X? ( x11-libs/libX11 )
"
RDEPEND="
	${DEPEND}
	vim? ( || ( app-editors/vim app-editors/gvim ) )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
"

DOCS="AUTHORS FAQ NEWS README TODO"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i -e '/stat.h/a#include <sys/sysmacros.h>' "${S}/src/modes/file_info.c" \
		|| die
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

src_compile() {
	default
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ${DOCS}

	if use vim; then
		local t
		for t in app plugin; do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins "${S}"/data/vim/doc/"${t}"/"${PN}"*
		done
	fi

	if use vim-syntax; then
		local t
		for t in ftdetect ftplugin syntax; do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins "${S}"/data/vim/"${t}"/"${PN}".vim
		done
	fi
}

src_test() {
	emake check
}

pkg_postinst() {
	xdg_desktop_database_update
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
	xdg_desktop_database_update
	use vim && update_vim_helptags
}
