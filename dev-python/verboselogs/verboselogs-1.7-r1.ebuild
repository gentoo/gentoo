# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Verbose logging for Python's logging module"
HOMEPAGE="
	https://github.com/xolox/python-verboselogs/
	https://pypi.org/project/verboselogs/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-skip-sandbox-violation-test.patch"
)

distutils_enable_sphinx docs
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	epytest ${PN}/tests.py
}
