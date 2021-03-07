# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

MY_PN=vim-${PN}
MY_P=${MY_PN}-${PV}

DESCRIPTION="vim plugin: a simple alignment plugin"
HOMEPAGE="https://github.com/junegunn/vim-easy-align https://www.vim.org/scripts/script.php?script_id=4520"
SRC_URI="https://github.com/junegunn/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="${PN}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default
	rm -rv test || die
}
