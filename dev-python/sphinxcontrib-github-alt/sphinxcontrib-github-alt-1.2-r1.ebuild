# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

MY_PN="sphinxcontrib_github_alt"

DESCRIPTION="Link to GitHub issues, pull requests, commits and users from Sphinx docs"
HOMEPAGE="https://github.com/jupyter/sphinxcontrib_github_alt"
SRC_URI="https://github.com/jupyter/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	!dev-python/sphinxcontrib_github_alt
"
BDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"
