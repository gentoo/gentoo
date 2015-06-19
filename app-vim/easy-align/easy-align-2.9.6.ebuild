# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/easy-align/easy-align-2.9.6.ebuild,v 1.1 2014/10/18 04:05:30 radhermit Exp $

EAPI=5
inherit vim-plugin

MY_PN=vim-${PN}
MY_P=${MY_PN}-${PV}

DESCRIPTION="vim plugin: a simple alignment plugin"
HOMEPAGE="https://github.com/junegunn/vim-easy-align http://www.vim.org/scripts/script.php?script_id=4520"
SRC_URI="https://github.com/junegunn/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	rmdir test || die
}
