# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A hack for test fixtures, needed for hypothesis inside py.test"
HOMEPAGE="
	https://github.com/untitaker/pytest-subtesthack/
	https://pypi.org/project/pytest-subtesthack/
"
SRC_URI="
	https://github.com/untitaker/pytest-subtesthack/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
