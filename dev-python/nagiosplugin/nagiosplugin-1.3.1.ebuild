# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy{,3} python{2_7,3_{5,6,7}} )

inherit distutils-r1

DESCRIPTION="A class library for writing nagios-compatible plugins"
HOMEPAGE="https://github.com/mpounsett/nagiosplugin https://nagiosplugin.readthedocs.io"
# PyPI tarball lacks doc and tests
# https://github.com/mpounsett/nagiosplugin/pull/22
SRC_URI="https://github.com/mpounsett/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

LICENSE="ZPL"
SLOT="0"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_compile_all() {
	if use doc; then
		sphinx-build doc doc/_build/html || die
		HTML_DOCS=( doc/_build/html/. )
	fi
}

python_test() {
	pytest -vv tests || die "tests failed with ${EPYTHON}"
}
