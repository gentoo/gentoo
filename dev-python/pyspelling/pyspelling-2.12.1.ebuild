# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/facelessuser/pyspelling
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Spell checker automation tool"
HOMEPAGE="
	https://github.com/facelessuser/pyspelling/
	https://pypi.org/project/pyspelling/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	|| ( app-text/aspell app-text/hunspell )

	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/soupsieve-1.8[${PYTHON_USEDEP}]
	>=dev-python/wcmatch-6.5[${PYTHON_USEDEP}]
"
# The package can use either aspell or hunspell but tests both if both
# are installed.  Therefore, we need to ensure that both have English
# dictionary installed.
BDEPEND="
	test? (
		app-dicts/aspell-en
		app-dicts/myspell-en
		dev-vcs/git
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
