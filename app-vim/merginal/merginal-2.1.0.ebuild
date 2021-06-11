# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

MY_PN=vim-${PN}
MY_P=${MY_PN}-${PV}

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/idanarye/${MY_PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/idanarye/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="vim script: fugitive extension to manage and merge git branches"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=4955 https://github.com/idanarye/vim-merginal/"
LICENSE="vim"

RDEPEND="app-vim/fugitive"

VIM_PLUGIN_HELPFILES="${PN}"
