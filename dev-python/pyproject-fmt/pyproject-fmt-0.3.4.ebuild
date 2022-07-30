# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Format your pyproject.toml file"
HOMEPAGE="
	https://github.com/tox-dev/pyproject-fmt/
	https://pypi.org/project/pyproject-fmt/
"
SRC_URI="
	https://github.com/tox-dev/pyproject-fmt/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.10[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-mock-3.7[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
