# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Pure python implementation of magic file detection"
HOMEPAGE="
	https://github.com/cdgriffith/puremagic/
	https://pypi.org/project/puremagic/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

DOCS=( CHANGELOG.md README.rst )

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
