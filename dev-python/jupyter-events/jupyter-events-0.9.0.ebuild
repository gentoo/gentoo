# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Jupyter Event System library"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/jupyter_events/
	https://pypi.org/project/jupyter-events/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

# jsonschema[format-nongpl] deps are always on in our ebuild
RDEPEND="
	>=dev-python/jsonschema-4.18.0[${PYTHON_USEDEP}]
	>=dev-python/python-json-logger-2.0.4[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.3[${PYTHON_USEDEP}]
	dev-python/referencing[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-console-scripts[${PYTHON_USEDEP}]
		dev-python/rich[${PYTHON_USEDEP}]
	)
"

# TODO: package jupyterlite-sphinx
# distutils_enable_sphinx docs
distutils_enable_tests pytest
