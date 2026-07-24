# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1 pypi

DESCRIPTION="Dictdiffer is a library that helps you to diff and patch dictionaries"
HOMEPAGE="
	https://github.com/inveniosoftware/dictdiffer/
	https://pypi.org/project/dictdiffer/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
# Requires self to be already installed
#distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

python_prepare_all() {
	# remove a bunch of random linters from pytest run
	sed -e 's:--isort::' \
		-e 's:--pydocstyle::' \
		-e 's:--cov=dictdiffer::' \
		-e 's:--cov-report=term-missing::' \
		-i pyproject.toml || die

	distutils-r1_python_prepare_all
}
