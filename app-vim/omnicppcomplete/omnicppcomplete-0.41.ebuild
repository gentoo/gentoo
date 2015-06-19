# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/omnicppcomplete/omnicppcomplete-0.41.ebuild,v 1.4 2013/11/30 12:54:59 johu Exp $

EAPI="2"

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: C/C++ omni-completion with ctags database"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1520"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=7722 -> ${P}.zip"

LICENSE="vim.org"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=">=dev-util/ctags-5.7"

S="${WORKDIR}"

VIM_PLUGIN_HELPFILES="${PN}"
