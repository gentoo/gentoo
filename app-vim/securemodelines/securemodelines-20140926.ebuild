# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/securemodelines/securemodelines-20140926.ebuild,v 1.3 2014/12/11 07:40:35 radhermit Exp $

EAPI=5
inherit vim-plugin

DESCRIPTION="vim plugin: secure, user-configurable modeline support"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1876 https://github.com/ciaranm/securemodelines"
LICENSE="vim"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~sparc-fbsd ~x86-fbsd"

VIM_PLUGIN_HELPTEXT="Make sure that you disable vim's builtin modeline support if you have
enabled it in your .vimrc."
