# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE='sqlite'

inherit distutils-r1 git-r3

DESCRIPTION="Collection of tools missing from the Python standard library"
HOMEPAGE="https://mathema.tician.de/software/pytools/"
EGIT_REPO_URI="https://github.com/inducer/pytools"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.6.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
