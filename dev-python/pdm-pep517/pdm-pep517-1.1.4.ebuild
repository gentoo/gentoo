# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

# upstream has renamed the repo but the legacy branch is still published
# as pdm-pep517, sigh
MY_P=pdm-backend-${PV}
DESCRIPTION="A PEP 517 backend for PDM that supports PEP 621 metadata"
HOMEPAGE="
	https://pypi.org/project/pdm-pep517/
	https://github.com/pdm-project/pdm-backend/
"
SRC_URI="
	https://github.com/pdm-project/pdm-backend/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/cerberus-1.3.4[${PYTHON_USEDEP}]
	dev-python/license-expression[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3-r2[${PYTHON_USEDEP}]
	>=dev-python/tomli-2[${PYTHON_USEDEP}]
	dev-python/tomli-w[${PYTHON_USEDEP}]
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
	rm -r pdm/pep517/_vendor || die
	find -name '*.py' -exec sed \
		-e 's:from pdm\.pep517\._vendor\.:from :' \
		-e 's:from pdm\.pep517\._vendor ::' \
		-i {} + || die
	distutils-r1_src_prepare
}

src_test() {
	git config --global user.email "test@example.com" || die
	git config --global user.name "Test User" || die
	distutils-r1_src_test
}
