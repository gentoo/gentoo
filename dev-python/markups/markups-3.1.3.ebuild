# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_P=${P^}
DESCRIPTION="A wrapper around various text markups"
HOMEPAGE="
	https://pymarkups.readthedocs.io/en/latest/
	https://github.com/retext-project/pymarkups
	https://pypi.org/project/Markups/
"
SRC_URI="mirror://pypi/${MY_P:0:1}/${PN^}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/python-markdown-math[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		app-text/pytextile[${PYTHON_USEDEP}]
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pymdown-extensions[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
distutils_enable_sphinx docs
