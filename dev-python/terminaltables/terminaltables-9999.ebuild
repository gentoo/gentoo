# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
EGIT_REPO_URI="https://github.com/Robpol86/${PN}.git"
inherit distutils-r1 git-r3

DESCRIPTION="Generate simple tables in terminals from a nested list of strings"
HOMEPAGE="https://robpol86.github.io/terminaltables/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

BDEPEND="
	test? (
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/colorclass[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/termcolor[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
