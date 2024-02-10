# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: edit files using sudo or su"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=2709 https://github.com/chrisbra/SudoEdit.vim"
LICENSE="vim"
KEYWORDS="amd64 x86"
VIM_PLUGIN_HELPFILES="SudoEdit.txt"

RDEPEND="|| ( app-admin/sudo sys-apps/shadow )"

src_prepare() {
	# remove unused windows related files
	rm autoload/{sudo.cmd,SudoEdit.vbs} || die
	default
}
