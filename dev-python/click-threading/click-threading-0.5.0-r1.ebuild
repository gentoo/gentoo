# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Multithreaded Click apps made easy"
HOMEPAGE="
	https://github.com/click-contrib/click-threading/
	https://pypi.org/project/click-threading/
"
SRC_URI="
	https://github.com/click-contrib/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/click-5.0[${PYTHON_USEDEP}]
"

DOCS=( README.rst )

distutils_enable_tests pytest
