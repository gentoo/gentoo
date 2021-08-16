# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Auto-generate API documentation for Python projects"
HOMEPAGE="https://pdoc3.github.io/pdoc/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="AGPL-3+"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i \
		-e "/setuptools_git/d" \
		-e "/setuptools_scm/d" \
		setup.py || die
}

distutils_enable_tests unittest
