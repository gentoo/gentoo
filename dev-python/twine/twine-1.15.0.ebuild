# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python{2_7,3_{6,7,8,9}} pypy3 )

inherit distutils-r1

DESCRIPTION="Collection of utilities for publishing packages on PyPI"
HOMEPAGE="https://twine.readthedocs.io/ https://github.com/pypa/twine https://pypi.org/project/twine/"
SRC_URI="https://github.com/pypa/twine/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/tqdm-4.14[${PYTHON_USEDEP}]
	>=dev-python/pkginfo-1.4.2[${PYTHON_USEDEP}]
	>=dev-python/readme_renderer-21.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.8.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/pyblake2[${PYTHON_USEDEP}]' python{2_7,3_5})
"

PATCHES=(
	"${FILESDIR}/twine-1.15.0-tests.patch"
)

python_prepare_all() {
	# requires internet
	rm -f tests/test_integration.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
