# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Common logic to the TOML formatter"
HOMEPAGE="
	https://github.com/tox-dev/toml-fmt-common/
	https://pypi.org/project/toml-fmt-common/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.2[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
