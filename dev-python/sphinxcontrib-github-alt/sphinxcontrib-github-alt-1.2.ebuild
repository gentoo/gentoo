# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

MY_PN="sphinxcontrib_github_alt"

DESCRIPTION="Link to GitHub issues, pull requests, commits and users from Sphinx docs"
HOMEPAGE="https://github.com/jupyter/sphinxcontrib_github_alt"
SRC_URI="https://github.com/jupyter/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~m68k ~ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"
