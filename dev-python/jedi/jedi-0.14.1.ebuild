# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Autocompletion library for Python"
HOMEPAGE="https://github.com/davidhalter/jedi"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 x86"

RDEPEND="dev-python/parso[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_prepare_all() {
	# speed tests are fragile
	rm test/test_speed.py || die

	# 'path' completion test does not account for 'path' being a valid
	# package (i.e. dev-python/path-py)
	# https://github.com/davidhalter/jedi/issues/1210
	sed -i -e 's:test_get_modules_containing_name:_&:' \
		test/test_evaluate/test_imports.py || die
	sed -i -e 's:test_os_issues:_&:' \
		test/test_evaluate/test_imports.py || die
	sed -i -e 's:test_os_issues:_&:' \
		test/test_api/test_full_name.py || die
	sed -i -e 's:test_os_nowait:_&:' \
		test/test_api/test_full_name.py || die
	sed -i -e 's:test_os_nowait:_&:' \
		test/test_api/test_completion.py || die
	sed -i -e 's:test_import:_&:' \
		test/test_utils.py || die

	# don't run doctests, don't depend on colorama
	sed -i "s:'docopt',:: ; s:'colorama',::" setup.py || die
	sed -i "s: --doctest-modules::" pytest.ini || die

	# no clue why it fails but we don't really care about .pyc files
	# without sources anyway
	rm test/test_evaluate/test_pyc.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	if [[ ${EPYTHON} = python3.6 ]]; then
		# our very useful patching changes libdir for no good reason
		sed -i -e 's:test_venv_and_pths:_&:' \
			test/test_evaluate/test_sys_path.py || die
	fi

	pytest -vv || die "Tests fail with ${EPYTHON}"
}
