# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: ultimate auto completion system"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2620"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	default

	mv autoload/vital.vim "autoload/${PN}vital.vim" || die
}
