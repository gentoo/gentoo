# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8} )
# [options.entry_points] is present in setup.cfg but it is empty
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Tools for working with iterables. Complements itertools and more_itertools"
HOMEPAGE="https://github.com/jaraco/jaraco.itertools"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# TODO: remove six
# https://github.com/jaraco/jaraco.itertools/pull/6
RDEPEND="
	>=dev-python/namespace-jaraco-2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/inflect[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-4.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)
"
distutils_enable_sphinx docs '>=dev-python/jaraco-packaging-3.2' \
	'>=dev-python/rst-linker-1.9'

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	# https://github.com/jaraco/jaraco.itertools/issues/7
	if [[ "${EPYTHON}" == pypy3 ]]; then
		local extra_pytest_args="--deselect jaraco/itertools.py::jaraco.itertools.always_iterable"
	fi
	# Override pytest options to skip flake8
	PYTHONPATH=. pytest -vv --override-ini="addopts=--doctest-modules" \
		${extra_pytest_args} || die "tests failed with ${EPYTHON}"
}

# https://wiki.gentoo.org/wiki/Project:Python/Namespace_packages#File_collisions_between_pkgutil-style_packages
python_install() {
	rm "${BUILD_DIR}"/lib/jaraco/__init__.py || die
	# note: eclass may default to --skip-build in the future
	distutils-r1_python_install --skip-build
}
