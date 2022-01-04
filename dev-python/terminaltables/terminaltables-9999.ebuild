# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 git-r3

DESCRIPTION="Generate simple tables in terminals from a nested list of strings"
HOMEPAGE="https://robpol86.github.io/terminaltables/"
EGIT_REPO_URI="https://github.com/matthewdeanmartin/${PN}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

BDEPEND="
	test? (
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/colorclass[${PYTHON_USEDEP}]
		dev-python/termcolor[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
