# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
VIM_PLUGIN_VIM_VERSION="7.2"

inherit vim-plugin

DESCRIPTION="vim plugin: a git wrapper for vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2975"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=15542 -> ${P}.zip"
LICENSE="vim"
KEYWORDS="amd64 x86 ~ppc-macos ~x64-macos"
IUSE=""

VIM_PLUGIN_HELPFILES="fugitive.txt"

DEPEND="app-arch/unzip"
RDEPEND="dev-vcs/git"

S=${WORKDIR}
