# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Generate source code for Python classes from a JSON schema"
HOMEPAGE="
	https://pypi.org/project/jschema-to-python/
	https://github.com/microsoft/jschema-to-python/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/jsonpickle[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
