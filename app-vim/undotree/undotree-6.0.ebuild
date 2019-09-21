# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin vcs-snapshot

DESCRIPTION="vim plugin: display your undo history in a graph"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=4177 https://github.com/mbbill/undotree"
SRC_URI="https://github.com/mbbill/${PN}/archive/rel_${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="amd64 x86"
