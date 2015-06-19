# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/perl-support/perl-support-4.14.ebuild,v 1.2 2012/12/04 08:33:02 radhermit Exp $

EAPI=4

inherit vim-plugin

MY_PN="${PN}.vim"
DESCRIPTION="vim plugin: Perl-IDE - Write and run Perl scripts using menus and hotkeys"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=556"
SRC_URI="https://github.com/vim-scripts/${MY_PN}/tarball/${PV} -> ${P}.tar.gz"
LICENSE="GPL-2 GPL-2+"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="dev-perl/Perl-Tags
	dev-perl/Perl-Critic"

src_unpack() {
	unpack ${A}
	mv *-${MY_PN}-* "${S}"
}

src_prepare() {
	# Don't set tabstop and shiftwidth
	sed -i -e '/=4/s/^/"/' ftplugin/perl.vim
}

src_install() {
	dodoc doc/{ChangeLog,perl-hot-keys.pdf}
	rm doc/{ChangeLog,perl-hot-keys.*,pmdesc3.text} || die
	vim-plugin_src_install
}
