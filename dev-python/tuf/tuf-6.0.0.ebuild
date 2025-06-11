# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A secure updater framework for Python"
HOMEPAGE="
	https://github.com/theupdateframework/python-tuf/
	https://pypi.org/project/tuf/
"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	<dev-python/urllib3-3[${PYTHON_USEDEP}]
	<dev-python/securesystemslib-2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_test() {
	cd tests || die
	local -x PYTHONPATH="..:${PYTHONPATH}"
	eunittest
}
