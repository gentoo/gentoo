# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: run tests with py.test from within vim"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=3424"
SRC_URI="https://www.vim.org/scripts/download_script.php?src_id=18178 -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="dev-python/pytest"

S="${WORKDIR}/${PN}.vim"
