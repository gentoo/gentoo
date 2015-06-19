# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/extra-syntax/extra-syntax-4.ebuild,v 1.15 2014/03/06 10:30:21 ago Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: metapackage for all extra syntax packages"
HOMEPAGE="http://www.vim.org/"
LICENSE="metapackage"
KEYWORDS="amd64 ~mips ~ppc ppc64 x86"
SRC_URI=""
IUSE=""

RDEPEND="${RDEPEND}
	app-vim/bnf-syntax
	app-vim/brainfuck-syntax
	app-vim/cfengine-syntax
	app-vim/dhcpd-syntax
	app-vim/ebnf-syntax
	app-vim/eruby-syntax
	app-vim/fluxbox-syntax
	app-vim/gentoo-syntax
	app-vim/gtk-syntax
	app-vim/help-extra-syntax
	app-vim/nagios-syntax
	app-vim/ntp-syntax
	app-vim/pam-syntax
	app-vim/pgn-syntax
	app-vim/selinux-syntax
	app-vim/wikipedia-syntax
	app-vim/xquery-syntax
	app-vim/xsl-syntax"

src_install() {
	:
}
