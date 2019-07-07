# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: Go development plugin for Vim"
HOMEPAGE="https://github.com/fatih/vim-go"
SRC_URI="https://github.com/fatih/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}"

RESTRICT="test"

src_compile() {
	# safely skip `make test` triggered by `make` as it runs `go get` commands
	# TODO: see :GoInstallBinaries (https://github.com/fatih/vim-go/blob/master/doc/vim-go.txt)
	:;
}
