# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

MY_PN="tcomment_vim"

DESCRIPTION="vim plugin: an extensible and universal comment toggler"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=1173
	https://github.com/tomtom/tcomment_vim"
SRC_URI="https://github.com/tomtom/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

DOCS=( CHANGES.TXT README )

src_prepare() {
	default
	rm -r etc spec addon* || die
}
