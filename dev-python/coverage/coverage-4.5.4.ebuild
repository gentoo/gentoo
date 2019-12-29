# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{5,6,7,8}} pypy{,3} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Code coverage measurement for Python"
HOMEPAGE="https://coverage.readthedocs.io/en/latest/ https://pypi.org/project/coverage/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc64 ~sparc"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
BDEPEND="
	>=dev-python/setuptools-18.4[${PYTHON_USEDEP}]
	test? (
		dev-python/PyContracts[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/unittest-mixins-1.4[${PYTHON_USEDEP}]
	)
"

DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}/coverage-4.5.4-tests.patch"
)

src_prepare() {
	# avoid the dep on xdist, run tests verbosely
	sed -i -e '/^addopts/s:-n3:-v:' setup.cfg || die
	distutils-r1_src_prepare
}

python_compile() {
	if [[ ${EPYTHON} == python2.7 ]]; then
		local CFLAGS="${CFLAGS} -fno-strict-aliasing"
		export CFLAGS
	fi

	distutils-r1_python_compile
}

python_test() {
	distutils_install_for_testing
	local bindir=${TEST_DIR}/scripts

	pushd tests/eggsrc >/dev/null || die
	distutils_install_for_testing
	popd >/dev/null || die

	"${EPYTHON}" igor.py zip_mods || die
	PATH="${bindir}:${PATH}" "${EPYTHON}" igor.py test_with_tracer py || die

	# No C extensions under pypy
	if [[ ${EPYTHON} != pypy* ]]; then
		cp -l -- "${TEST_DIR}"/lib/*/coverage/*.so coverage/ || die
		PATH="${bindir}:${PATH}" "${EPYTHON}" igor.py test_with_tracer c || die
	fi

	# clean up leftover "egg1" directory
	rm -rf build/lib/egg1 || die
}
