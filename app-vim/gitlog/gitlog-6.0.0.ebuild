# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/PAntoine/vimgitlog.git"
	inherit git-r3
else
	SRC_URI="https://github.com/PAntoine/vimgitlog/archive/version_${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/vim${PN}-version_${PV}
fi

DESCRIPTION="vim plugin: git log and diff plugin for vim"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=4294 https://github.com/PAntoine/vimgitlog/"
LICENSE="Artistic"

VIM_PLUGIN_HELPFILES="${PN}.txt"
