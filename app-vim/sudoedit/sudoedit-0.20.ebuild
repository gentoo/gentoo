# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/sudoedit/sudoedit-0.20.ebuild,v 1.1 2014/11/01 09:23:21 radhermit Exp $

EAPI=5
inherit vim-plugin

DESCRIPTION="vim plugin: edit files using sudo or su"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2709 https://github.com/chrisbra/SudoEdit.vim"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"
VIM_PLUGIN_HELPFILES="SudoEdit.txt"

RDEPEND="|| ( app-admin/sudo sys-apps/shadow )"

src_prepare() {
	# remove unused windows related file
	rm autoload/sudo.cmd || die
}
