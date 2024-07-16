# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

DESCRIPTION="A PEP 517 backend for PDM that supports PEP 621 metadata"
HOMEPAGE="
	https://pypi.org/project/pdm-backend/
	https://github.com/pdm-project/pdm-backend/
"
SRC_URI="
	https://github.com/pdm-project/pdm-backend/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# see src/pdm/backend/_vendor/vendor.txt
RDEPEND="
	>=dev-python/editables-0.5[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
	>=dev-python/pyproject-metadata-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/tomli-w-1.0.0[${PYTHON_USEDEP}]

	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"
# setuptools are used to build C extensions
RDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	rm -r src/pdm/backend/_vendor || die
	find -name '*.py' -exec sed \
		-e 's:from pdm\.backend\._vendor\.:from :' \
		-e 's:from pdm\.backend\._vendor ::' \
		-e 's:import pdm\.backend\._vendor\.:import :' \
		-i {} + || die
	distutils-r1_src_prepare
}

src_compile() {
	# this must not be set during src_test()
	local -x PDM_BUILD_SCM_VERSION=${PV}
	distutils-r1_src_compile
}

src_test() {
	git config --global user.email "test@example.com" || die
	git config --global user.name "Test User" || die
	distutils-r1_src_test
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -k "not [hg"
}
