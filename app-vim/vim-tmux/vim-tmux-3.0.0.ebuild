# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: tmux support for vim"
HOMEPAGE="https://github.com/tmux-plugins/vim-tmux"
SRC_URI="https://github.com/tmux-plugins/${PN}/archive/v${PV}.zip -> ${P}.zip"
LICENSE="vim.org"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND="
	app-misc/tmux
	app-arch/unzip"

RDEPEND="${DEPEND}"

src_compile() {
	:;
}
