# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/dhcpd-syntax/dhcpd-syntax-20030825.ebuild,v 1.18 2013/02/09 11:36:34 ulm Exp $

inherit vim-plugin eutils

DESCRIPTION="vim plugin: syntax highlighting for dhcpd.conf"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=744"
LICENSE="vim"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for dhcpd.conf files."

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-multiple-addresses.patch
}
