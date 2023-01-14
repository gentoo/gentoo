# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Flow control and backpressure for event-driven applications"
HOMEPAGE="
	https://github.com/twisted/tubes/
	https://pypi.org/project/Tubes/
"
SRC_URI="
	https://github.com/twisted/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
