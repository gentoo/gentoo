# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{5,6}} )

inherit distutils-r1

DESCRIPTION="See what a program does before deciding whether you really want it to happen"
HOMEPAGE="https://github.com/p-e-w/maybe https://pypi.org/project/maybe/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/blessings[${PYTHON_USEDEP}]
	dev-python/python-ptrace[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	>=dev-python/pytest-runner-2.7[${PYTHON_USEDEP}]
"
