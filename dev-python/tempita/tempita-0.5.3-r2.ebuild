# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python{2_7,3_{6,7,8}} )

inherit distutils-r1

MY_COMMIT="97392d008cc8"

DESCRIPTION="A very small text templating language"
HOMEPAGE="https://pypi.org/project/Tempita/"
# Tests are not published on PyPI
SRC_URI="https://bitbucket.org/ianb/${PN}/get/${MY_COMMIT}.tar.gz -> ${P}-bitbucket.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

PATCHES=( "${FILESDIR}/${P}-pypy-tests.patch" )

S="${WORKDIR}/ianb-${PN}-${MY_COMMIT}"

python_prepare_all() {
	# Remove reference to a non-existent CSS file
	# in order to make sphinx use its default theme.
	sed -i '/^html_style =/d' docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# We need to append to sys.path, otherwise pytest imports
	# the module from ${S} (before it was 2to3'd)
	pytest --import-mode=append -vv tests/test_template.txt docs/index.txt \
		|| die "Tests failed with ${EPYTHON}"
}
