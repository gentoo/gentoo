# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: syntax highlighting for udev rules files"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=1381"
LICENSE="vim"
KEYWORDS="amd64 ~hppa ~mips ppc sparc x86"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for udev.rules files. These files
are automatically detected by filename; manual loading is also possible,
via :set filetype=udev"

PATCHES=( "${FILESDIR}/${P}-ftdetect.patch" )
