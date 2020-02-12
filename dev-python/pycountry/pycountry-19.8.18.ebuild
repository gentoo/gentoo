# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Database of countries, subdivisions, languages, currencies and script"
HOMEPAGE="https://bitbucket.org/flyingcircus/pycountry"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64 ~ia64 ppc ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	# https://bitbucket.org/techtonik/pycountry/issue/8/test_locales-pycountry-015-pypy
	pushd "${BUILD_DIR}"/lib > /dev/null || die
	if [[ ${EPYTHON} == pypy* ]]; then
		sed -e 's:test_locales:_&:' -i pycountry/tests/test_general.py || die
	fi
	pytest -o cache_dir="${T}" -vv || die
	popd > /dev/null || die
}
