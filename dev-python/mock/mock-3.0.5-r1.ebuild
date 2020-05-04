# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Rolling backport of unittest.mock for all Pythons"
HOMEPAGE="https://github.com/testing-cabal/mock"
SRC_URI="https://github.com/testing-cabal/mock/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/funcsigs[${PYTHON_USEDEP}]
	' -2)
	>=dev-python/six-1.9[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-17.1[${PYTHON_USEDEP}]"

python_test() {
	# Upstream supports running tests only in their dream pristine
	# environment.  pytest doesn't work at all if mock is already
	# installed.  We can use plain unittest but we have to reinvent
	# test filtering.
	cp -r mock/tests "${BUILD_DIR}"/lib/mock/ || die
	cd "${BUILD_DIR}"/lib || die
	if ! python_is_python3; then
		rm mock/tests/*py3* || die
	fi

	# https://github.com/testing-cabal/mock/commit/d6b42149bb87cf38729eef8a100c473f602ef7fa
	if [[ ${EPYTHON} == pypy* ]]; then
		sed -i -e 's:def test_copy:def _test_copy:' \
			mock/tests/testmock.py || die
	fi

	"${EPYTHON}" -m unittest discover -v || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGELOG.rst README.rst )

	distutils-r1_python_install_all
}
