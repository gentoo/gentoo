# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=flit
inherit distutils-r1

DESCRIPTION="Link to GitHub issues, pull requests, commits and users from Sphinx docs"
HOMEPAGE="https://pypi.org/project/sphinxcontrib_github_alt/
	https://github.com/jupyter/sphinxcontrib_github_alt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"
