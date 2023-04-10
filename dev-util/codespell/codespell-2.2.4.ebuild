# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Check text files for common misspellings"
HOMEPAGE="https://pypi.org/project/codespell https://github.com/codespell-project/codespell"

# Code licensed under GPL-2, dictionary licensed under CC-BY-SA-3.0
LICENSE="GPL-2 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="test? ( dev-python/chardet[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${PN}-2.2.4-drop-coverage.patch )

distutils_enable_tests pytest
