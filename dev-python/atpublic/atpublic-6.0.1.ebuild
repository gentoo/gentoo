# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="A decorator to populate __all__ and the module globals"
HOMEPAGE="
	https://gitlab.com/warsaw/public/
	https://pypi.org/project/atpublic/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv sparc x86"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/importlib-resources-5.10[${PYTHON_USEDEP}]
	' 3.10 3.11)
"
BDEPEND="
	test? (
		dev-python/sybil[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
