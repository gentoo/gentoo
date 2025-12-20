# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Compatibility API between asyncio/Twisted/Trollius"
HOMEPAGE="
	https://github.com/crossbario/txaio/
	https://pypi.org/project/txaio/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/test[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# we certainly don't need to test "python setup.py sdist" here
	test/test_packaging.py
)

pkg_postinst() {
	optfeature "Twisted support" "dev-python/twisted dev-python/zope-interface"
}
