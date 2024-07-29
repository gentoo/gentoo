# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..13} )
PYTHON_REQ_USE='sqlite'

inherit distutils-r1 pypi

DESCRIPTION="Reference implementation of the Jupyter Notebook format"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/nbformat/
	https://pypi.org/project/nbformat/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/fastjsonschema-2.15[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.6[${PYTHON_USEDEP}]
	>=dev-python/jupyter-core-5.1[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-nodejs-version[${PYTHON_USEDEP}]
	test? (
		dev-python/testpath[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	dev-python/myst-parser \
	dev-python/pydata-sphinx-theme \
	dev-python/sphinxcontrib-github-alt \
	dev-python/sphinxcontrib-spelling
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# requires pep440 package, which is not really relevant for us
	tests/test_api.py
)
