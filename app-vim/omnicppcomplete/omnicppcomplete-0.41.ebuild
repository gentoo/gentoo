# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: C/C++ omni-completion with ctags database"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=1520"
SRC_URI="https://www.vim.org/scripts/download_script.php?src_id=7722 -> ${P}.zip"

LICENSE="vim.org"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=">=dev-util/ctags-5.7"

S="${WORKDIR}"

VIM_PLUGIN_HELPFILES="${PN}"
