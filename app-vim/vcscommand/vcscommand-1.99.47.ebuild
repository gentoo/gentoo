# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: CVS/SVN/SVK/git/bzr/hg integration plugin"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=90"
LICENSE="MIT"
KEYWORDS="amd64 ~hppa ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

RDEPEND="!app-vim/cvscommand"

VIM_PLUGIN_HELPFILES="${PN}.txt"
