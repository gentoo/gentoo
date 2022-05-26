# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/scrooloose/nerdcommenter.git"
	inherit git-r3
else
	SRC_URI="https://github.com/scrooloose/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86 ~x86-linux ~sparc64-solaris"
fi

DESCRIPTION="vim plugin: easy commenting of code for many filetypes"
HOMEPAGE="https://github.com/scrooloose/nerdcommenter https://www.vim.org/scripts/script.php?script_id=1218"
LICENSE="WTFPL-2 "

VIM_PLUGIN_HELPFILES="NERD_commenter.txt"
