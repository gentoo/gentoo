# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="Tools for working with iterables. Complements itertools and more_itertools"
HOMEPAGE="https://github.com/jaraco/jaraco.itertools"
SRC_URI="mirror://pypi/${MY_P::1}/${PN/-/.}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-python/inflect[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-4.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs '>=dev-python/jaraco-packaging-3.2' \
	'>=dev-python/rst-linker-1.9'
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local deselect=()
	[[ ${EPYTHON} == pypy3 ]] && deselect+=(
		# https://github.com/jaraco/jaraco.itertools/issues/7
		jaraco/itertools.py::jaraco.itertools.always_iterable
	)

	# needed for doctests to work
	> jaraco/__init__.py || die
	epytest --doctest-modules ${deselect[@]/#/--deselect }
}
