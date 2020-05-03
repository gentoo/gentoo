# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Tools to supplement packaging Python releases"
HOMEPAGE="https://github.com/jaraco/jaraco.packaging"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/importlib_metadata[${PYTHON_USEDEP}]
	>=dev-python/namespace-jaraco-2[${PYTHON_USEDEP}]
	>=dev-python/six-1.4[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/toml[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs '>=dev-python/rst-linker-1.9'

python_test() {
	# Skip one test which requires network access
	# Override pytest options to skip flake8
	PYTHONPATH=. pytest -vv -k "not test_revived_distribution" \
		--override-ini="addopts=--doctest-modules" \
		|| die "tests failed with ${EPYTHON}"
}

# https://wiki.gentoo.org/wiki/Project:Python/Namespace_packages#File_collisions_between_pkgutil-style_packages
python_install() {
	rm "${BUILD_DIR}"/lib/jaraco/__init__.py || die
	# note: eclass may default to --skip-build in the future
	distutils-r1_python_install --skip-build
}
