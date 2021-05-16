# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit vim-plugin

DESCRIPTION="vim plugin: Cfengine 3 configuration files syntax"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=2904 https://github.com/neilhwatson/vim_cf3"
LICENSE="GPL-3+"
KEYWORDS="~alpha amd64 arm ~ia64 ~mips ppc ppc64 ~s390 sparc x86"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for Cfengine configuration
files. Detection is by filename (/var/cfengine/inputs/)."
