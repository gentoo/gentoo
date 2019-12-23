# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

MY_PN="tcomment_vim"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/tomtom/tcomment_vim.git"
	inherit git-r3
else
	SRC_URI="https://github.com/tomtom/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="vim plugin: an extensible and universal comment toggler"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=1173 https://github.com/tomtom/tcomment_vim"
LICENSE="GPL-3"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	default
	rm -r README LICENSE.TXT etc spec addon* || die
}
