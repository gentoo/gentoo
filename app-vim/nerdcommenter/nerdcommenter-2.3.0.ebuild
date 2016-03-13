# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: easy commenting of code for many filetypes"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1218"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=14455 -> ${P}.zip"
LICENSE="WTFPL-2 "
KEYWORDS="amd64 x86 ~x86-linux ~x86-macos ~sparc64-solaris"

VIM_PLUGIN_HELPFILES="NERD_commenter.txt"

DEPEND="app-arch/unzip"

S="${WORKDIR}"
