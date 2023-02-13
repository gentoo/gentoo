# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

MY_P=jquery-${PV}
DESCRIPTION="Extension to include jQuery on newer Sphinx releases"
HOMEPAGE="
	https://github.com/sphinx-contrib/jquery/
	https://pypi.org/project/sphinxcontrib.jquery/
"
SRC_URI="
	https://github.com/sphinx-contrib/jquery/archive/refs/tags/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

# MIT for jQuery
LICENSE="0BSD MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~riscv"

BDEPEND="
	test? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
