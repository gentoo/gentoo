# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} pypy3 )
inherit distutils-r1

MY_P=${P#backports-}
DESCRIPTION="Backport of the standard library zoneinfo module"
HOMEPAGE="https://github.com/pganssle/zoneinfo/"
SRC_URI="
	https://github.com/pganssle/zoneinfo/archive/${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/importlib_resources[${PYTHON_USEDEP}]
	' python3_6 pypy3)"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/dataclasses[${PYTHON_USEDEP}]
		' python3_6)
		$(python_gen_cond_dep '
			dev-python/importlib_metadata[${PYTHON_USEDEP}]
		' python3_{6,7})
		>=dev-python/hypothesis-5.7.0[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

# pytest is used only for one skip, and requires unpackaged
# pytest-subtests
distutils_enable_tests unittest

python_test() {
	if [[ ${EPYTHON} == pypy3 ]]; then
		# pypy3.6 does not support dataclasses, and the backport
		# does not work with pypy
		local pypy3_version=$(best_version -b 'dev-python/pypy3')
		if [[ ${pypy3_version} != *_p37* ]]; then
			einfo "Skipping tests on pypy3.6 due to missing deps"
			return
		fi
	fi

	"${EPYTHON}" -m unittest discover -v ||
		die "Tests failed with ${EPYTHON}"
}

python_install() {
	# avoid file collisions
	rm "${BUILD_DIR}"/lib/backports/__init__.py || die
	distutils-r1_python_install
}
