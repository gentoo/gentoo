# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/nerdtree/nerdtree-4.1.0.ebuild,v 1.1 2010/06/27 16:36:22 spatz Exp $

EAPI=3

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: A tree explorer plugin for navigating the filesystem"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1658"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=11834 -> ${P}.zip"
LICENSE="WTFPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

VIM_PLUGIN_HELPFILES="NERD_tree"

DEPEND="app-arch/unzip"
RDEPEND=""
