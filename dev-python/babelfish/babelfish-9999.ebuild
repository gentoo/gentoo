# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 git-r3

DESCRIPTION="Python library to work with countries and languages"
HOMEPAGE="
	https://github.com/Diaoul/babelfish/
	https://pypi.org/project/babelfish/
"
EGIT_REPO_URI="https://github.com/Diaoul/babelfish.git"

LICENSE="BSD"
SLOT="0"

distutils_enable_tests pytest
