# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P=sphinxcontrib_github_alt-${PV}
DESCRIPTION="Link to GitHub issues, pull requests, commits and users from Sphinx docs"
HOMEPAGE="
	https://github.com/jupyter/sphinxcontrib_github_alt/
	https://pypi.org/project/sphinxcontrib_github_alt/
"
SRC_URI="
	https://github.com/jupyter/sphinxcontrib_github_alt/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	!dev-python/sphinxcontrib_github_alt
"
BDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
"
