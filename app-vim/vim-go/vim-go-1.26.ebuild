# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: Go development plugin for Vim"
HOMEPAGE="https://github.com/fatih/vim-go"
SRC_URI="https://github.com/fatih/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="dev-go/gopls"

DOCS=( README.md CHANGELOG.md )

src_compile() {
	# safely skip `make test` triggered by `make` as it runs `go get` commands
	# TODO: Is :GoInstallBinaries still necessary? For details see:
	#       https://github.com/fatih/vim-go/blob/master/doc/vim-go.txt
	:;
}

src_install(){
	insinto /usr/share/vim/vimfiles/
	doins -r templates

	vim-plugin_src_install
}
