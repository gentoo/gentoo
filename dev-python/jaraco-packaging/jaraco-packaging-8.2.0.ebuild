# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Tools to supplement packaging Python releases"
HOMEPAGE="https://github.com/jaraco/jaraco.packaging"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/importlib_metadata[${PYTHON_USEDEP}]' pypy3 python3_{6,7})
"
DEPEND="
	dev-python/toml[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs '>=dev-python/rst-linker-1.9'
distutils_enable_tests pytest

python_test() {
	# Override pytest options to skip flake8
	pytest -vv --override-ini="addopts=--doctest-modules" \
		|| die "tests failed with ${EPYTHON}"
}

# https://wiki.gentoo.org/wiki/Project:Python/Namespace_packages#File_collisions_between_pkgutil-style_packages
python_install() {
	rm "${BUILD_DIR}"/lib/jaraco/__init__.py || die
	distutils-r1_python_install
}
