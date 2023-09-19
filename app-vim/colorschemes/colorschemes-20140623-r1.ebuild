# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edos2unix vim-plugin

DESCRIPTION="vim plugin: a collection of color schemes from vim.org"
HOMEPAGE="https://www.vim.org/"

LICENSE="vim GPL-2 GPL-2+ GPL-3 GPL-3+ MIT BSD WTFPL-2 public-domain vim.org"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides a collection of color schemes for vim. To switch
color schemes, use :colorscheme schemename (tab completion is available
for scheme names). To automatically set a scheme at startup, please see
:help vimrc."

src_prepare() {
	default
	eapply -p0 "${S}"/patches/*.patch
	rm -rf patches/

	# fix line endings
	edos2unix colors/*
}
