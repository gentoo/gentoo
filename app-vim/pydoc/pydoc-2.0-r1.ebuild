# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit vim-plugin python-single-r1

DESCRIPTION="vim plugin: integrates python documentation view and search tool"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=910 https://github.com/fs111/pydoc.vim"
SRC_URI="https://github.com/fs111/${PN}.vim/tarball/${PV} -> ${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ppc64 x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="app-arch/unzip"
RDEPEND="${PYTHON_DEPS}"

src_unpack() {
	default
	mv * "${P}" || die
}
