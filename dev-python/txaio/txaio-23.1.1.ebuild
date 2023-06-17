# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Compatibility API between asyncio/Twisted/Trollius"
HOMEPAGE="
	https://github.com/crossbario/txaio/
	https://pypi.org/project/txaio/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_sphinx docs \
	'>=dev-python/sphinxcontrib-spelling-2.1.2' \
	'>=dev-python/sphinx-rtd-theme-0.1.9'
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# we certainly don't need to test "python setup.py sdist" here
	test/test_packaging.py
)

pkg_postinst() {
	optfeature "Twisted support" "dev-python/twisted dev-python/zope-interface"
}
