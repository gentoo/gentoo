# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A rewrite of Python's builtin doctest module but without all the weirdness"
HOMEPAGE="https://github.com/Erotemic/xdoctest"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
# dev-python/nbformat-5.1.{0..2} did not install package data
BDEPEND="
	test? (
		|| (
			>=dev-python/nbformat-5.1.2-r1[${PYTHON_USEDEP}]
			<dev-python/nbformat-5.1[${PYTHON_USEDEP}]
		)
	)"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme

python_test() {
	local -x PYTHONPATH=.
	pytest -vv || die "Test fail with ${EPYTHON}"
}
