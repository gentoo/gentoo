# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 git-r3

DESCRIPTION="Python library to work with countries and languages"
HOMEPAGE="https://github.com/Diaoul/babelfish https://pypi.org/project/babelfish/"
EGIT_REPO_URI="https://github.com/Diaoul/${PN}.git"

LICENSE="BSD"
SLOT="0"

distutils_enable_tests setup.py
