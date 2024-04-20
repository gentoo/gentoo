# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: integrate vim with R"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=2628"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/R"

VIM_PLUGIN_HELPFILES="r-plugin.txt"

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "This plugin requires the vimcom R package to be installed,"
		elog "see https://github.com/jalvesaq/VimCom for instructions."
	fi
}
