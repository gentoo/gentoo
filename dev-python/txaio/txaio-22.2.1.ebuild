# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 optfeature

DESCRIPTION="Compatibility API between asyncio/Twisted/Trollius"
HOMEPAGE="https://github.com/crossbario/txaio https://pypi.org/project/txaio/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86 ~amd64-linux ~x86-linux"

distutils_enable_sphinx docs \
	'>=dev-python/sphinxcontrib-spelling-2.1.2' \
	'>=dev-python/sphinx_rtd_theme-0.1.9'
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Take out failing tests known to pass when run manually
	# we certainly don't need to test "python setup.py sdist" here
	test/test_packaging.py
)

pkg_postinst() {
	optfeature "Twisted support" "dev-python/twisted dev-python/zope-interface"
}
