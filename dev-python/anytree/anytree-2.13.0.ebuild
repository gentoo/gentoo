# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Tree data library"
HOMEPAGE="
	https://github.com/c0fec0de/anytree
	https://pypi.org/project/anytree/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/test2ref[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	epytest -o addopts=
}
