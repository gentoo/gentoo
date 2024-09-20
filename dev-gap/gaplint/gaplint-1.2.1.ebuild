# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1

DESCRIPTION="Linter for GAP"
HOMEPAGE="
	https://github.com/james-d-mitchell/gaplint
	https://pypi.org/project/gaplint
"

# Use the github tarball because it includes the tests.
SRC_URI="https://github.com/james-d-mitchell/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
