# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Automatically formats Python code to conform to the PEP 8 style guide"
HOMEPAGE="https://github.com/hhatto/autopep8 https://pypi.org/project/autopep8/"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/hhatto/${PN}.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm64 ~ia64 ppc sparc x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=dev-python/pycodestyle-2.6.0[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/pydiff[${PYTHON_USEDEP}] )"

distutils_enable_tests setup.py
