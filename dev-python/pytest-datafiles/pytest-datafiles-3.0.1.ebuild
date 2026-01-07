# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Create a 'tmp_path' containing predefined files/directories"
HOMEPAGE="
	https://github.com/omarkohl/pytest-datafiles/
	https://pypi.org/project/pytest-datafiles/
"
SRC_URI="
	https://github.com/omarkohl/pytest-datafiles/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	>=dev-python/pytest-6.2.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( "${PN}" )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest
