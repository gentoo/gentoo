# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A rewrite of Python's builtin doctest module but without all the weirdness"
HOMEPAGE="https://github.com/Erotemic/ubelt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme

python_prepare_all() {
	# fails because the ebuild environment location is not the expected location
	sed -i -e 's:test_xdoc_console_script_location:_&:' \
		testing/test_entry_point.py || die

	# xdoctest has to be in PATH for this to work
	sed -i -e 's:test_xdoc_console_script_exec:_&:' \
		testing/test_entry_point.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH="${WORKDIR}/${P}"
	pytest -vv || die "Test fail with ${EPYTHON}"
}
