# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_PN="sphinxcontrib_github_alt"

DESCRIPTION="Link to GitHub issues, pull requests, commits and users from Sphinx docs"
HOMEPAGE="https://github.com/jupyter/sphinxcontrib_github_alt"
SRC_URI="https://github.com/jupyter/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~x86"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"
BDEPEND=${RDEPEND}

S="${WORKDIR}/${MY_PN}-${PV}"
