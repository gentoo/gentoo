# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/cfengine-syntax/cfengine-syntax-20141019.ebuild,v 1.2 2015/02/09 00:35:38 radhermit Exp $

EAPI=5
inherit vim-plugin

DESCRIPTION="vim plugin: Cfengine 3 configuration files syntax"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2904 https://github.com/neilhwatson/vim_cf3"
LICENSE="GPL-3+"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 s390 sparc x86"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for Cfengine configuration
files. Detection is by filename (/var/cfengine/inputs/)."
