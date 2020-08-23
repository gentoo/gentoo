# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="Making it easy to write async iterators in Python 3.5"
HOMEPAGE="https://github.com/python-trio/async_generator https://pypi.org/project/async_generator/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

DOCS=( README.rst )

python_test() {
	pushd "${BUILD_DIR}/lib" >/dev/null || die
	pytest -vv || die "Tests fail with ${EPYTHON}"
	rm -rf .pytest_cache || die
	popd >/dev/null || die
}
