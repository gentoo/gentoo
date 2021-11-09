# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} pypy3 )
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
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

BDEPEND="
	test? (
		>=dev-python/hypothesis-5.7.0[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

# pytest is used only for one skip, and requires unpackaged
# pytest-subtests
distutils_enable_tests unittest

PATCHES=(
	# fix segv in py3.8.7rc1+
	# https://github.com/pganssle/zoneinfo/pull/97
	"${FILESDIR}"/${P}-py38.patch
)

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
