# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Simple powerful testing with Python"
HOMEPAGE="https://pytest.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 hppa ~ia64 ~ppc ~ppc64 sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# When bumping, please check setup.py for the proper py version
PY_VER="1.5.0"

# pathlib2 has been added to stdlib before py3.6, but pytest needs __fspath__
# support, which only came in py3.6.
RDEPEND="
	>=dev-python/attrs-17.4.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/importlib_metadata[${PYTHON_USEDEP}]
	' python3_{6,7} pypy3)
	>=dev-python/more-itertools-4.0.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pluggy-0.12[${PYTHON_USEDEP}]
	<dev-python/pluggy-1
	>=dev-python/py-${PY_VER}[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]"

# flake cause a number of tests to fail
DEPEND="${RDEPEND}
	test? (
		>=dev-python/hypothesis-3.56[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/xmlschema[${PYTHON_USEDEP}]
		!!dev-python/flaky
	)"

PATCHES=(
	"${FILESDIR}/${PN}"-4.5.0-strip-setuptools_scm.patch
)

python_prepare_all() {
	grep -qF "py>=${PY_VER}" setup.py || die "Incorrect dev-python/py dependency"

	# fragile to warnings from other packages (setuptools)
	# little value for us to run it
	sed -i -e 's:test_no_warnings:_&:' \
		testing/test_meta.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing

	"${EPYTHON}" -m pytest -vv --lsof -rfsxX \
		|| die "tests failed with ${EPYTHON}"
}
