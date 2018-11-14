# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="Highlight FIXME/TODO/CUSTOM keywords in a separate list"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=2607"
SRC_URI="https://github.com/vim-scripts/${PN}.vim/tarball/${PV} -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	default
	mv vim-* "${P}" || die
}
