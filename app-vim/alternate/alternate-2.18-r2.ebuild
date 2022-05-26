# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: quickly switch between .c and .h files"
HOMEPAGE="https://github.com/vim-scripts/a.vim https://www.vim.org/scripts/script.php?script_id=31"

SRC_URI="
	https://github.com/vim-scripts/a.vim/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://www.vim.org/scripts/download_script.php?src_id=6347 -> ${PN}.txt"

LICENSE="alternate"
KEYWORDS="~alpha amd64 ~ia64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides a new :A command which will switch between a .c
file and the associated .h file. There is also :AS to split windows and
:AV to split windows vertiically."

VIM_PLUGIN_HELPFILES="${PN}.txt"

PATCHES=(
	"${FILESDIR}"/${P}-hh-cc-alternation.patch
)

S="${WORKDIR}/a.vim-${PV}"

src_prepare() {
	default
	mkdir -p "${S}/doc" || die
	cp "${DISTDIR}/${PN}.txt" "${S}/doc" || die
}
