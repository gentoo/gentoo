# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Simple Python library to perform a 3-way merge between strings"
HOMEPAGE="https://github.com/spyder-ide/three-merge
	https://pypi.org/project/three-merge/"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}-gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/diff-match-patch[${PYTHON_USEDEP}]"

BDEPEND="test? (
	dev-python/flaky[${PYTHON_USEDEP}]
	dev-python/pytest-timeout[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
