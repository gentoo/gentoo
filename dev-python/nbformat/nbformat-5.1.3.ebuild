# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE='sqlite'

inherit distutils-r1

DESCRIPTION="Reference implementation of the Jupyter Notebook format"
HOMEPAGE="https://jupyter.org"
# missing on pypi
SRC_URI="
	https://github.com/jupyter/nbformat/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/jsonschema-2.4.0[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.1[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	"
BDEPEND="
	test? (
		dev-python/fastjsonschema[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
	"

distutils_enable_sphinx docs \
	dev-python/numpydoc
distutils_enable_tests pytest
