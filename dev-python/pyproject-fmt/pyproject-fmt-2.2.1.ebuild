# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Format your pyproject.toml file"
HOMEPAGE="
	https://github.com/tox-dev/pyproject-fmt/
	https://pypi.org/project/pyproject-fmt/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 arm ~arm64 ~loong ~ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	~dev-python/pyproject-fmt-rust-1.1.6[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	' 3.10)
"
# tox is called as a subprocess, to get targets from tox.ini
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-mock-3.10[${PYTHON_USEDEP}]
		dev-python/tox
	)
"

distutils_enable_tests pytest
