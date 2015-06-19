# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/vcscommand/vcscommand-1.99.47.ebuild,v 1.2 2014/12/14 04:38:26 radhermit Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: CVS/SVN/SVK/git/bzr/hg integration plugin"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=90"
LICENSE="MIT"
KEYWORDS="amd64 ~hppa ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"

RDEPEND="!app-vim/cvscommand"

VIM_PLUGIN_HELPFILES="${PN}.txt"
