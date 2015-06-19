# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/udev-syntax/udev-syntax-20051016-r1.ebuild,v 1.6 2011/05/22 23:43:19 josejx Exp $

inherit vim-plugin eutils

DESCRIPTION="vim plugin: syntax highlighting for udev rules files"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1381"
LICENSE="vim"
KEYWORDS="amd64 hppa ~mips ppc sparc x86"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for udev.rules files. These files
are automatically detected by filename; manual loading is also possible,
via :set filetype=udev"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-ftdetect.patch"
}
