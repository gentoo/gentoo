# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE='sqlite'

inherit distutils-r1

DESCRIPTION="Reference implementation of the Jupyter Notebook format"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/nbformat/
	https://pypi.org/project/nbformat/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/fastjsonschema[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.6[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.1[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/testpath[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	dev-python/numpydoc \
	dev-python/myst_parser
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${P}-no-node.patch"
)

EPYTEST_IGNORE=(
	# requires pep440 package, which is not really relevant for us
	tests/test_api.py
)
