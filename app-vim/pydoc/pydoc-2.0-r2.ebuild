# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit vim-plugin python-single-r1

DESCRIPTION="vim plugin: integrates python documentation view and search tool"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=910
	https://github.com/fs111/pydoc.vim"
SRC_URI="
	https://github.com/fs111/${PN}.vim/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${PN}.vim-${PV}

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
