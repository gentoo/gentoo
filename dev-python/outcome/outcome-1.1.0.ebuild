# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Capture the outcome of Python function calls"
HOMEPAGE="
	https://github.com/python-trio/outcome
	https://pypi.org/project/outcome
"
SRC_URI="https://github.com/python-trio/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="dev-python/attrs[${PYTHON_USEDEP}]"

BDEPEND="test? (
	dev-python/async_generator[${PYTHON_USEDEP}]
	dev-python/pytest-asyncio[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinxcontrib-trio
