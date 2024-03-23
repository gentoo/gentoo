# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

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
KEYWORDS="~amd64 ~arm64 ~ppc ~sparc ~x86"

RDEPEND="
	>=dev-python/pytest-3.6[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
